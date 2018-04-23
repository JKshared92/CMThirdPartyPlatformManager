//
//  CMPlatformManager.h
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/15.
//  Copyright © 2017年 comma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPlatformHandler.h"

@interface CMPlatformManager : NSObject

/**
 单例
 
 @return 返回单例本身
 */
+ (instancetype)sharedManager;


/**
 初始化配置
 
 @param application 本应用
 @param launchOptions 应用启动的参数
 */
- (void)thirdPartyPlatformConfigWithApplication:(UIApplication *)application
                  didFinishLaunchingWithOptions:(NSDictionary  *)launchOptions;


/**
 是否响应第三方应用的回调请求
 
 @param application 本应用
 @param url 回调的URL
 @param options 回调的参数
 @return 是否响应的结果
 */
- (BOOL)thirdPartyPlatformCanOpenUrlWithApplication:(UIApplication *)application
                                            openURL:(NSURL *)url
                                            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;



/**
 注册第三方平台服务

 @param handler 第三方平台的服务
 */
- (void)registrationPlatformHandler:(CMPlatformHandler<CMPlatformHandlerProtocol> *)handler;



/**
 判断本机上是否有安装第三方平台的APP

 @param platformIdentifier 平台的标识
 @return 返回是否安装的结果
 */
- (BOOL)isThirdPlatformInstalled:(CMPlatformIdentifier)platformIdentifier;


/**
 通过第三方平台授权登录

 @param platformIdentifier 平台标识
 @param viewController 从哪个页面进行的第三方授权
 @param loginBlock 登录后的回调
 */
- (void)loginInWithPlatform:(CMPlatformIdentifier)platformIdentifier
         fromViewController:(UIViewController *)viewController
                 loginBlock:(LoginBlock)loginBlock;



/**
 通过第三方平台进行订单支付

 @param platformIdentifier 平台标识
 @param orderModel 订单的内容
 @param payBlock 支付后的回调
 */
- (void)payWithPlateform:(CMPlatformIdentifier)platformIdentifier
              orderModel:(id<CMPlatformOrderModel>)orderModel
                payBlock:(PayBlock)payBlock;



/**
 将制定内容分享给第三方平台

 @param platformIdentifier 分享的平台
 @param shareModel 分享的内容
 @param shareBlock 分享后的回调
 */
- (void)shareWithPlateform:(CMPlatformIdentifier)platformIdentifier
                shareModel:(CMPlatformShareModel *)shareModel
                shareBlock:(ShareBlock)shareBlock;
@end
