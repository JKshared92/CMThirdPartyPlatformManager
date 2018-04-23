//
//  CMAppDelegate.m
//  CMThirdPartyPlatformManager
//
//  Created by comma on 04/23/2018.
//  Copyright (c) 2018 comma. All rights reserved.
//

#import "CMAppDelegate.h"

@import CMThirdPartyPlatformManager;

@implementation CMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    /**注册所需要的服务*/
    [[CMPlatformManager sharedManager] registrationPlatformHandler:[[AlipayHandler alloc] initWithAppScheme:@"your AppScheme"]];
    [[CMPlatformManager sharedManager] registrationPlatformHandler:[[WechatHandler alloc] initWithAppID:@"your AppID" appSecret:@"your appSecret" appScheme:@"your appScheme"]];
    [[CMPlatformManager sharedManager] registrationPlatformHandler:[[QQHandler alloc] initWithAppID:@"your AppID"]];
    
    [[CMPlatformManager sharedManager] thirdPartyPlatformConfigWithApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[CMPlatformManager sharedManager] thirdPartyPlatformCanOpenUrlWithApplication:app openURL:url options:options];
}

@end
