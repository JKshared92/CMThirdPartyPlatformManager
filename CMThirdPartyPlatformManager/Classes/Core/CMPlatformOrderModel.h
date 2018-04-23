//
//  CMPlatformOrderModel.h
//  Pods
//
//  Created by comma on 2018/2/9.
//

#import <Foundation/Foundation.h>

/**
 支付宝支付需要传递的参数和微信支付不尽相同，具体可查询各个平台相应的文档
 支付宝支付： https://docs.open.alipay.com/204/105295/
 微信支付：   https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_12&index=2
 */

@protocol CMPlatformOrderModel <NSObject>

@required

/** 第三方平台对交易数据的签名 */
- (NSString *)platformOrderSign;

@optional

/** 商家向平台申请的商家ID */
- (NSString *)platformOrderPartnerID;

/** 预支付订单 */
- (NSString *)platformOrderPrepayID;

/** 商户网站唯一订单号 */
- (NSString *)platformOrderID;

/** 随机串，防重发 */
- (NSString *)platformOrderNoncestr;

/** 时间戳，防重发 */
- (UInt32)platformOrderTimeStamp;

@end
