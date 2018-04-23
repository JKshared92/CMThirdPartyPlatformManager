//
//  CMPlatformDefine.h
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/15.
//  Copyright © 2017年 comma. All rights reserved.
//

#ifndef CMPlatformDefine_h
#define CMPlatformDefine_h

static NSErrorDomain const CMPlatformErrorDomain = @"CMPlatformErrorDomain";

// 平台标识
typedef NSString *CMPlatformIdentifier;

// 分享渠道
typedef NSString *CMPlatformShareType;

/**  支付的结果 */
typedef NS_ENUM(NSInteger, CMPayResult) {
    CMPayResultSuccess           = 0, //支付成功
    CMPayResultFailed            = 1, //支付失败
    CMPayResultCancel            = 2, //取消支付
};

/**  登录的结果 */
typedef NS_ENUM(NSInteger, CMLoginResult) {
    CMLoginResultSuccess         = 0, //登录成功
    CMLoginResultFailed          = 1, //登录失败
    CMLoginResultCancel          = 2, //取消登录
};

/**  分享的结果 */
typedef NS_ENUM(NSInteger, CMShareResult) {
    CMShareResultSuccess         = 0, //分享成功
    CMShareResultFailed          = 1, //分享失败
    CMShareResultCancel          = 2, //取消分享
};

/**  分享的类型 */
typedef NS_ENUM(NSInteger, CMMediaType) {
    CMMediaText                  = 0, //文字
    CMMediaImage                 = 1, //图片
    CMMediaURL                   = 2, //网址（新闻/广告等）
    CMMediaVideo                 = 3, //视频
};

#endif /* CMPlatformDefine_h */
