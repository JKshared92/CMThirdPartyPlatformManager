//
//  AlipayHandler.m
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/16.
//

#import "AlipayHandler.h"
#import <AlipaySDK/AlipaySDK.h>

CMPlatformIdentifier const PlatformIdentifierAlipay = @"PlatformIdentifierAlipay";

@interface AlipayHandler ()

@property (copy, nonatomic) NSString *appScheme;

@end

@implementation AlipayHandler

- (instancetype)init {
    NSAssert(YES, @"请通过(initWithAppScheme:)方法来完成初始化");
    return nil;
}

- (instancetype)initWithAppScheme:(NSString *)appScheme {
    self = [super init];
    if (self) {
        self.appScheme = appScheme;
    }
    return self;
}

- (void)handleAlipayResult:(NSDictionary *)resultDic {
    if (!self.payBlock) {
        return;
    }
    
    NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
    CMPayResult payResult;
    NSError *error;
    switch (resultStatus.integerValue) {
        case 9000:
            payResult = CMPayResultSuccess;
            break;
        case 8000:
            payResult = CMPayResultFailed;
            error  = [NSError errorWithDomain:CMPlatformErrorDomain code:8000 userInfo:@{NSLocalizedDescriptionKey:@"订单正在处理中,请稍后查询订单列表中订单的支付状态"}];
            break;
        case 4000:
            payResult = CMPayResultFailed;
            error  = [NSError errorWithDomain:CMPlatformErrorDomain code:4000 userInfo:@{NSLocalizedDescriptionKey:@"订单支付失败"}];
            break;
        case 5000:
            payResult = CMPayResultFailed;
            error = [NSError errorWithDomain:CMPlatformErrorDomain code:5000 userInfo:@{NSLocalizedDescriptionKey:@"请勿重复发起支付订单"}];
            break;
        case 6001:
            payResult = CMPayResultCancel;
            error  = [NSError errorWithDomain:CMPlatformErrorDomain code:5000 userInfo:@{NSLocalizedDescriptionKey:@"用户取消支付"}];
            break;
        case 6002:
            payResult = CMPayResultFailed;
            error  = [NSError errorWithDomain:CMPlatformErrorDomain code:5000 userInfo:@{NSLocalizedDescriptionKey:@"支付宝网络连接出错，请检查网络是否可用后再试"}];
            break;
        case 6004:
            payResult = CMPayResultFailed;
            error  = [NSError errorWithDomain:CMPlatformErrorDomain code:8000 userInfo:@{NSLocalizedDescriptionKey:@"订单正在处理中,请稍后查询订单列表中订单的支付状态"}];
            break;
        default:
            payResult = CMPayResultFailed;
            NSString *errorMessage = [resultDic objectForKey:@"memo"];
            error  = [NSError errorWithDomain:CMPlatformErrorDomain code:8000 userInfo:@{NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@(%@)",errorMessage?:@"未知错误",resultStatus]}];
            break;
    }
    
    self.payBlock(payResult, error);
    self.payBlock = nil;
}

#pragma mark - CMPlatformHandlerProtocol
- (BOOL)thirdPartyPlatformCanOpenUrlWithApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        __weak __typeof(self)weakSelf = self;
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [weakSelf handleAlipayResult:resultDic];
        }];
        return YES;
    }
    return NO;
}

- (CMPlatformIdentifier)platformIdentifier {
    return PlatformIdentifierAlipay;
}

- (BOOL)isThirdPlatformInstalled {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL  URLWithString:@"alipay://"]];
}

#pragma mark - CMPlatformPayProtocol
- (void)payOrderModel:(id<CMPlatformOrderModel>)orderModel
             payBlock:(PayBlock)payBlock {
    if (!orderModel.platformOrderSign) {
        if (payBlock) {
            NSError *error = [NSError errorWithDomain:CMPlatformErrorDomain code:CMPayResultFailed userInfo:@{NSLocalizedDescriptionKey:@"请求参数错误,请稍后再试"}];
            payBlock(CMPayResultFailed,error);
        }
        return;
    }
    
    self.payBlock = payBlock;
    
    __weak __typeof(self)weakSelf = self;
    [[AlipaySDK defaultService] payOrder:orderModel.platformOrderSign fromScheme:self.appScheme callback:^(NSDictionary *resultDic) {
        [weakSelf handleAlipayResult:resultDic];
    }];
}

@end
