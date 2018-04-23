//
//  QQHandler.m
//  Pods
//
//  Created by comma on 2017/11/27.
//

#import "QQHandler.h"
#import <TencentOpenAPI/TencentOAuth.h>

CMPlatformIdentifier const PlatformIdentifierQQ       = @"PlatformIdentifierQQ";

CMPlatformShareType  const PlatformShareTypeQQSession = @"PlatformShareTypeQQSession";
CMPlatformShareType  const PlatformShareTypeQQZone    = @"PlatformShareTypeQQZone";

@interface QQHandler ()<TencentApiInterfaceDelegate,TencentSessionDelegate>

@property (strong, nonatomic) NSString *appID;
@property (strong, nonatomic) TencentOAuth *qqAuth;

@end

@implementation QQHandler

- (instancetype)init {
    NSAssert(YES, @"请通过(initWithAppID:)方法来完成初始化");
    return nil;
}

- (instancetype)initWithAppID:(NSString *)appID {
    self = [super init];
    if (self) {
        self.appID = appID;
    }
    return self;
}

#pragma mark - CMPlatformHandlerProtocol
- (BOOL)thirdPartyPlatformCanOpenUrlWithApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [TencentApiInterface handleOpenURL:url delegate:self];
    return [TencentOAuth HandleOpenURL:url];
}

- (CMPlatformIdentifier)platformIdentifier {
    return PlatformIdentifierQQ;
}

- (BOOL)isThirdPlatformInstalled {
    return [TencentOAuth iphoneQQInstalled] || [TencentOAuth iphoneTIMInstalled];
}

#pragma mark - CMPlatformLoginProtocol
- (void)loginFromViewController:(UIViewController *)viewController loginBlock:(LoginBlock)loginBlock {
    if ([TencentOAuth iphoneQQInstalled]) {
        self.qqAuth.authShareType = AuthShareType_QQ;
    }else if ([TencentOAuth iphoneTIMInstalled]) {
        self.qqAuth.authShareType = AuthShareType_TIM;
    }
    
    NSArray *permissions = @[kOPEN_PERMISSION_GET_USER_INFO,
                             kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                             kOPEN_PERMISSION_GET_VIP_INFO,
                             kOPEN_PERMISSION_ADD_SHARE];
    if ([self.qqAuth authorize:permissions]) {
        self.loginBlock = loginBlock;
    }else {
        if (self.loginBlock) {
            NSError *error = [NSError errorWithDomain:CMPlatformErrorDomain code:CMLoginResultFailed userInfo:@{NSLocalizedDescriptionKey:@"登录出错,无法完成登录"}];
            self.loginBlock(CMLoginResultFailed, nil, nil, error);
        }
        self.loginBlock = nil;
        return;
    }
}

#pragma mark - CMPlatformShareProtocol
- (NSArray<CMPlatformShareType> *)supportShareTypes {
    return @[PlatformShareTypeQQSession,
             PlatformShareTypeQQZone];
}

- (void)shareWithShareModel:(CMPlatformShareModel *)shareModel shareBlock:(ShareBlock)shareBlock {
    if (!self.isThirdPlatformInstalled) {
        //未安装QQ
        if (shareBlock) {
            NSError *error = [NSError errorWithDomain:CMPlatformErrorDomain code:CMShareResultFailed userInfo:@{NSLocalizedDescriptionKey:@"未安装QQ客户端"}];
            shareBlock(CMShareResultFailed, error);
        }
        return;
    }
    
    if (shareModel.shareType != PlatformShareTypeQQSession && shareModel.shareType != PlatformShareTypeQQZone) {
        //未支持该分享渠道
        if (shareBlock) {
            NSError *error = [NSError errorWithDomain:CMPlatformErrorDomain code:CMShareResultFailed userInfo:@{NSLocalizedDescriptionKey:@"QQ版本较低，不支持此分享"}];
            shareBlock(CMShareResultFailed, error);
        }
        return;
    }
    
    if (shareModel.mediaType == CMMediaText) {

    }
}

#pragma mark - TencentApiInterfaceDelegate


#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin {
    if (!self.loginBlock) {
        return;
    }
    
    if (self.qqAuth.accessToken && self.qqAuth.openId) {
        self.loginBlock(CMLoginResultSuccess, self.qqAuth.accessToken, self.qqAuth.openId, nil);
    }else {
        NSError *error = [NSError errorWithDomain:CMPlatformErrorDomain code:CMLoginResultFailed userInfo:@{NSLocalizedDescriptionKey:@"无法获取用户信息"}];
        self.loginBlock(CMLoginResultSuccess, self.qqAuth.accessToken, self.qqAuth.openId, error);
    }
    
    self.loginBlock = nil;
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    if (!self.loginBlock) {
        return;
    }
    
    if (cancelled) {
        NSError *error = [NSError errorWithDomain:CMPlatformErrorDomain code:CMLoginResultCancel userInfo:@{NSLocalizedDescriptionKey:@"用户取消分享"}];
        self.loginBlock(CMLoginResultCancel, nil, nil, error);
    }else {
        NSError *error = [NSError errorWithDomain:CMPlatformErrorDomain code:CMLoginResultFailed userInfo:@{NSLocalizedDescriptionKey:@"QQ未知错误,无法登录，请稍后再试"}];
        self.loginBlock(CMLoginResultFailed, nil, nil, error);
    }
    
    self.loginBlock = nil;
}

- (void)tencentDidNotNetWork {
    if (!self.loginBlock) {
        return;
    }
    
    NSError *error = [NSError errorWithDomain:CMPlatformErrorDomain code:CMLoginResultFailed userInfo:@{NSLocalizedDescriptionKey:@"网络错误无法连接"}];
    self.loginBlock(CMLoginResultFailed, nil, nil, error);
    self.loginBlock = nil;
}

#pragma mark - lazyload
- (TencentOAuth *)qqAuth {
    if (!_qqAuth) {
        _qqAuth = [[TencentOAuth alloc] initWithAppId:self.appID andDelegate:self];
    }
    return _qqAuth;
}

@end
