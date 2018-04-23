//
//  CMPlatformHandler.h
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/15.
//  Copyright © 2017年 comma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CMPlatformHandlerProtocol.h"
#import "CMPlatformLoginProtocol.h"
#import "CMPlatformPayProtocol.h"
#import "CMPlatformShareProtocol.h"

@interface CMPlatformHandler : NSObject

@property (copy, nonatomic) LoginBlock loginBlock;
@property (copy, nonatomic) PayBlock   payBlock;
@property (copy, nonatomic) ShareBlock shareBlock;

/**
 初始化配置
 
 @param application 本应用
 @param launchOptions 应用启动的参数
 */
- (void)thirdPlatformConfigWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


@end
