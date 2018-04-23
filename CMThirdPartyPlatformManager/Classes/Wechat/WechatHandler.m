//
//  WechatHandler.m
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/16.
//  Copyright © 2018年 comma. All rights reserved.
//

#import "WechatHandler.h"
#import <WXApi.h>

CMPlatformIdentifier const PlatformIdentifierWechat = @"PlatformIdentifierWechat";

CMPlatformShareType  const PlatformShareTypeWechatSession = @"platformShareTypeWechatSession";
CMPlatformShareType  const PlatformShareTypeWechatTimeLine = @"platformShareTypeWechatTimeLine";
CMPlatformShareType  const PlatformShareTypeWechatFavorite = @"platformShareTypeWechatFavorite";

@interface WechatHandler ()<WXApiDelegate>

@property (copy, nonatomic) NSString *appID;
@property (copy, nonatomic) NSString *appSecret;
@property (copy, nonatomic) NSString *appScheme;

@end

@implementation WechatHandler

- (instancetype)init {
    NSAssert(YES, @"请通过(initWithAppID:appSecret:appScheme:)方法来完成初始化");
    return nil;
}

- (instancetype)initWithAppID:(NSString *)appID appSecret:(NSString *)appSecret appScheme:(NSString *)appScheme {
    self = [super init];
    if (self) {
        self.appID     = appID;
        self.appSecret = appSecret;
        self.appScheme = appScheme;
    }
    return self;
}

- (void)thirdPlatformConfigWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (self.appID) {
        [WXApi registerApp:self.appID enableMTA:NO];
    }
}

#pragma mark - CMPlatformHandlerProtocol
- (BOOL)thirdPartyPlatformCanOpenUrlWithApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

- (CMPlatformIdentifier)platformIdentifier {
    return PlatformIdentifierWechat;
}

- (BOOL)isThirdPlatformInstalled {
    return [WXApi isWXAppInstalled];
}

#pragma mark - CMPlatformLoginProtocol
- (void)loginFromViewController:(UIViewController *)viewController loginBlock:(LoginBlock)loginBlock {
    if ([self isThirdPlatformInstalled]) {
        SendAuthReq *authReq = [[SendAuthReq alloc] init];
        authReq.scope = @"snsapi_userinfo";
        authReq.openID = self.appID;
        authReq.state = self.appScheme;
        self.loginBlock = loginBlock;
        [WXApi sendAuthReq:authReq viewController:viewController delegate:self];
    }
}

#pragma mark - CMPlatformPayProtocol
- (void)payOrderModel:(id<CMPlatformOrderModel>)orderModel
             payBlock:(PayBlock)payBlock {
    if (!self.isThirdPlatformInstalled) {
        //未安装微信
        if (payBlock) {
            payBlock(CMPayResultFailed, [NSError errorWithDomain:CMPlatformErrorDomain code:WXErrCodeCommon userInfo:@{NSLocalizedDescriptionKey:@"未安装微信，请先安装微信后再次发起支付"}]);
        }
        return;
    }
    
    if (![orderModel respondsToSelector:@selector(platformOrderPartnerID)] || ![orderModel respondsToSelector:@selector(platformOrderPrepayID)] || ![orderModel respondsToSelector:@selector(platformOrderNoncestr)] || ![orderModel respondsToSelector:@selector(platformOrderTimeStamp)]) {
        //缺少必要的参数
        if (payBlock) {
            payBlock(CMPayResultFailed, [NSError errorWithDomain:CMPlatformErrorDomain code:WXErrCodeCommon userInfo:@{NSLocalizedDescriptionKey:@"支付参数错误,无法完成支付"}]);
        }
        return;
    }
    
    PayReq *req   = [[PayReq alloc] init];
    req.partnerId = orderModel.platformOrderPartnerID;
    req.prepayId  = orderModel.platformOrderPrepayID;
    req.nonceStr  = orderModel.platformOrderNoncestr;
    req.sign      = orderModel.platformOrderSign;
    req.timeStamp = orderModel.platformOrderTimeStamp;
    req.package   = @"Sign=WXPay";
    
    if ([WXApi sendReq:req]) {
        self.payBlock = payBlock;
    }else {
        if (payBlock) {
            payBlock(CMPayResultFailed,[NSError errorWithDomain:CMPlatformErrorDomain code:WXErrCodeUnsupport userInfo:@{NSLocalizedDescriptionKey:@"无法打开微信进行支付"}]);
        }
    }
}

#pragma mark - CMPlatformShareProtocol
- (NSArray<CMPlatformShareType> *)supportShareTypes {
    return @[PlatformShareTypeWechatSession,
             PlatformShareTypeWechatTimeLine,
             PlatformShareTypeWechatFavorite];
}

- (void)shareWithShareModel:(CMPlatformShareModel *)shareModel shareBlock:(ShareBlock)shareBlock {
    if (!self.isThirdPlatformInstalled) {
        //未安装微信
        if (shareBlock) {
            shareBlock(CMShareResultFailed, [NSError errorWithDomain:CMPlatformErrorDomain code:WXErrCodeCommon userInfo:@{NSLocalizedDescriptionKey:@"未安装微信"}]);
        }
        return;
    }
    
    if (shareModel.shareType != PlatformShareTypeWechatSession && shareModel.shareType != PlatformShareTypeWechatTimeLine && shareModel.shareType != PlatformShareTypeWechatFavorite) {
        //未支持该分享渠道
        if (shareBlock) {
            shareBlock(CMShareResultFailed, [NSError errorWithDomain:CMPlatformErrorDomain code:WXErrCodeUnsupport userInfo:@{NSLocalizedDescriptionKey:@"微信版本较低，不支持此分享"}]);
        }
        return;
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
    if (shareModel.shareType == PlatformShareTypeWechatTimeLine) {
        req.scene = WXSceneTimeline;
    }else if (shareModel.shareType == PlatformShareTypeWechatFavorite) {
        req.scene = WXSceneFavorite;
    }else {
        req.scene = WXSceneSession;
    }
    
    if (shareModel.mediaType == CMMediaText) {
        //文字分享
        req.bText = YES;
        req.text  = shareModel.title;
    }
    
    WXMediaMessage *msg = [WXMediaMessage message];
    msg.title = shareModel.title;
    msg.description = shareModel.describe;
    
    if (shareModel.mediaType == CMMediaImage && [shareModel.mediaObject isKindOfClass:[UIImage class]]) {
        //图片分享
        WXImageObject *imageObject = [WXImageObject object];
        NSData *imageData;
        if (UIImagePNGRepresentation(shareModel.mediaObject) == nil) {
            imageData = UIImageJPEGRepresentation(shareModel.mediaObject, 0.7);
        } else {
            imageData = UIImagePNGRepresentation(shareModel.mediaObject);
        }
        imageObject.imageData = imageData;
        msg.mediaObject = imageObject;
        req.message = msg;
    }
    
    if (shareModel.mediaType == CMMediaURL && [shareModel.mediaObject isKindOfClass:[NSURL class]]) {
        //网页分享（新闻/公告等）
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = [(NSURL *)shareModel.mediaObject absoluteString];
        msg.mediaObject = webpageObject;
        req.message = msg;
    }
    
    if (req.text.length < 1 && !req.message) {
         //无法识别分享的内容
        if (shareBlock) {
            shareBlock(CMShareResultFailed, [NSError errorWithDomain:CMPlatformErrorDomain code:WXErrCodeCommon userInfo:@{NSLocalizedDescriptionKey:@"无法识别的分享内容"}]);
        }
        return;
    }
    
    
    
    if ([WXApi sendReq:req]) {
        self.shareBlock = shareBlock;
    }else {
        if (shareBlock) {
            shareBlock(CMShareResultFailed, [NSError errorWithDomain:CMPlatformErrorDomain code:WXErrCodeUnsupport userInfo:@{NSLocalizedDescriptionKey:@"分享失败，请检查设置后再试"}]);
        }
    }
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        //分享结果回调
        switch (resp.errCode) {
            case WXSuccess:
                if (self.shareBlock) {
                    self.shareBlock(CMShareResultSuccess, nil);
                }
                break;
            case WXErrCodeUserCancel:
                if (self.shareBlock) {
                    self.shareBlock(CMShareResultCancel, [NSError errorWithDomain:CMPlatformErrorDomain code:(NSInteger)WXErrCodeUserCancel userInfo:@{NSLocalizedDescriptionKey:resp.errStr?:@"取消分享"}]);
                }
                break;
            default:
                if (self.shareBlock) {
                    self.shareBlock(CMShareResultFailed, [NSError errorWithDomain:CMPlatformErrorDomain code:(NSInteger)WXErrCodeUserCancel userInfo:@{NSLocalizedDescriptionKey:resp.errStr?:@"分享失败"}]);
                }
                break;
        }
        
        if (self.shareBlock) {
            self.shareBlock = nil;
        }
        
        return;
    }
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        //登录结果回调
        switch (resp.errCode) {
            case WXSuccess:
                if (self.loginBlock) {
                    self.loginBlock(CMLoginResultSuccess, [(SendAuthResp *)resp code], nil, nil);
                }
                break;
            case WXErrCodeUserCancel:
                if (self.loginBlock) {
                    NSError *error = [NSError errorWithDomain:CMPlatformErrorDomain code:(NSInteger)WXErrCodeUserCancel userInfo:@{NSLocalizedDescriptionKey:resp.errStr?:@"用户取消登录"}];
                    self.loginBlock(CMLoginResultCancel, nil, nil, error);
                }
                break;
            case WXErrCodeAuthDeny:
                if (self.loginBlock) {
                    NSError *error = [NSError errorWithDomain:CMPlatformErrorDomain code:(NSInteger)WXErrCodeAuthDeny userInfo:@{NSLocalizedDescriptionKey:resp.errStr?:@"用户未授权"}];
                    self.loginBlock(CMLoginResultFailed, nil, nil, error);
                }
                break;
            default:
                if (self.loginBlock) {
                    NSError *error = [NSError errorWithDomain:CMPlatformErrorDomain code:(NSInteger)resp.errCode userInfo:@{NSLocalizedDescriptionKey:resp.errStr?:@"授权登录出错"}];
                    self.loginBlock(CMLoginResultFailed, nil, nil, error);
                }
                break;
        }
        
        if (self.loginBlock) {
            self.loginBlock = nil;
        }
        
        return;
    }
    
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付结果回调
        switch (resp.errCode) {
            case WXSuccess:
                if (self.payBlock) {
                    self.payBlock(CMPayResultSuccess,nil);
                }
                break;
            case WXErrCodeUserCancel:
                if (self.payBlock) {
                    self.payBlock(CMPayResultCancel, [NSError errorWithDomain:CMPlatformErrorDomain code:(NSInteger)WXErrCodeUserCancel userInfo:@{NSLocalizedDescriptionKey:resp.errStr?:@"用户取消支付"}]);
                }
                break;
            default:
                if (self.payBlock) {
                    self.payBlock(CMPayResultFailed, [NSError errorWithDomain:CMPlatformErrorDomain code:(NSInteger)resp.errCode userInfo:@{NSLocalizedDescriptionKey:resp.errStr?:@"支付失败"}]);
                }
                break;
        }
        
        if (self.payBlock) {
            self.payBlock = nil;
        }
        return;
    }
}

@end
