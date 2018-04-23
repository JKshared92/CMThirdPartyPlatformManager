//
//  CMPlatformPayProtocol.h
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/15.
//  Copyright © 2017年 comma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPlatformHandlerProtocol.h"
#import "CMPlatformOrderModel.h"

typedef void (^PayBlock)(CMPayResult payResult, NSError *error);

@protocol CMPlatformPayProtocol <CMPlatformHandlerProtocol>

@required
/**
 通过第三方平台进行支付
 
 @param orderModel 支付的订单
 @param payBlock 支付后的回调
 */
- (void)payOrderModel:(id<CMPlatformOrderModel>)orderModel
        payBlock:(PayBlock)payBlock;

@end
