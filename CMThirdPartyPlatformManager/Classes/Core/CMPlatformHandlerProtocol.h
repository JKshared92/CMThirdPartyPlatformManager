//
//  CMPlatformHandlerProtocol.h
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/16.
//  Copyright © 2017年 comma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPlatformDefine.h"

@protocol CMPlatformHandlerProtocol <NSObject>

@required
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
 平台的唯一标识
 
 @return 返回平台的唯一标识
 */
- (CMPlatformIdentifier)platformIdentifier;


/**
 判断是否安装了第三方平台的APP
 
 @return 是否安装的结果
 */
- (BOOL)isThirdPlatformInstalled;

@end
