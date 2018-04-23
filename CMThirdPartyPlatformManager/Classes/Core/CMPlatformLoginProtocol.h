//
//  CMPlatformLoginProtocol.h
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/15.
//  Copyright © 2017年 comma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPlatformHandlerProtocol.h"

typedef void(^LoginBlock)(CMLoginResult loginResult, NSString *accessToken, NSString *userID, NSError *error);

@protocol CMPlatformLoginProtocol <CMPlatformHandlerProtocol>

@required
/**
 通过第三方授权登录
 
 @param viewController 唤起第三方登录的页面
 @param loginBlock 登录回调
 */
- (void)loginFromViewController:(UIViewController *)viewController
                     loginBlock:(LoginBlock)loginBlock;


@end
