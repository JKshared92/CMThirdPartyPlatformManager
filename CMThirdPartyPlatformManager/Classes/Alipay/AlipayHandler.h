//
//  AlipayHandler.h
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/16.
//

#import "CMPlatformHandler.h"

/***
    支付宝支付文档：https://docs.open.alipay.com/204/105295/
 */

// 平台标识
FOUNDATION_EXPORT CMPlatformIdentifier const PlatformIdentifierAlipay;

@interface AlipayHandler : CMPlatformHandler<CMPlatformPayProtocol>

- (instancetype)initWithAppScheme:(NSString *)appScheme;

@end
