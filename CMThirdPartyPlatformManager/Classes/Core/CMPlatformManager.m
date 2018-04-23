//
//  CMPlatformManager.m
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/15.
//  Copyright © 2017年 comma. All rights reserved.
//

#import "CMPlatformManager.h"

@interface CMPlatformManager ()

@property (strong, nonatomic) NSMutableDictionary *handlerConfig;

@end

@implementation CMPlatformManager

static CMPlatformManager *manager = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.handlerConfig = [NSMutableDictionary new];
    }
    return self;
}

- (void)thirdPartyPlatformConfigWithApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    for (CMPlatformHandler *handler in self.handlerConfig.allValues) {
        [handler thirdPlatformConfigWithApplication:application didFinishLaunchingWithOptions:launchOptions];
    }
}

- (BOOL)thirdPartyPlatformCanOpenUrlWithApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    for (CMPlatformHandler<CMPlatformHandlerProtocol> *handler in self.handlerConfig.allValues) {
        BOOL result = [handler thirdPartyPlatformCanOpenUrlWithApplication:application openURL:url options:options];
        if (result) {
            return YES;
        }
    }
    return NO;
}

- (void)registrationPlatformHandler:(CMPlatformHandler<CMPlatformHandlerProtocol> *)handler {
    if (!handler || ![handler conformsToProtocol:@protocol(CMPlatformHandlerProtocol)]) {
        NSAssert(YES, @"CMPlatformHandler不能为空且必须响应CMPlatformHandlerProtocol");
        return;
    }
    
    if ([self.handlerConfig.allValues indexOfObject:handler] == NSNotFound) {
        [self.handlerConfig setObject:handler forKey:handler.platformIdentifier];
    }
}

- (BOOL)isThirdPlatformInstalled:(CMPlatformIdentifier)platformIdentifier {
    CMPlatformHandler<CMPlatformHandlerProtocol> *handler = [self.handlerConfig objectForKey:platformIdentifier];
    if (handler) {
        return handler.isThirdPlatformInstalled;
    }
    return NO;
}

- (void)loginInWithPlatform:(CMPlatformIdentifier)platformIdentifier fromViewController:(UIViewController *)viewController loginBlock:(LoginBlock)loginBlock {
    id handler = [self.handlerConfig objectForKey:platformIdentifier];
    if (handler && [handler conformsToProtocol:@protocol(CMPlatformLoginProtocol)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [handler loginFromViewController:viewController loginBlock:loginBlock];
        });
    }
}

- (void)payWithPlateform:(CMPlatformIdentifier)platformIdentifier orderModel:(id<CMPlatformOrderModel>)orderModel payBlock:(PayBlock)payBlock {
    id handler = [self.handlerConfig objectForKey:platformIdentifier];
    if (handler && [handler conformsToProtocol:@protocol(CMPlatformPayProtocol)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [handler payOrderModel:orderModel payBlock:payBlock];
        });
    } else {
        if (payBlock) {
            payBlock(CMPayResultFailed,[NSError errorWithDomain:CMPlatformErrorDomain code:CMShareResultFailed userInfo:@{NSLocalizedDescriptionKey:@"未正确配置该平台，或该平台不支持支付"}]);
        }
    }
}

- (void)shareWithPlateform:(CMPlatformIdentifier)platformIdentifier shareModel:(CMPlatformShareModel *)shareModel shareBlock:(ShareBlock)shareBlock {
    id handler = [self.handlerConfig objectForKey:platformIdentifier];
    if (handler && [handler conformsToProtocol:@protocol(CMPlatformShareProtocol)]) {
        if ([[handler supportShareTypes] indexOfObject:shareModel.shareType] == NSNotFound) {
            if (shareBlock) {
                shareBlock(CMShareResultFailed, [NSError errorWithDomain:CMPlatformErrorDomain code:CMShareResultFailed userInfo:@{NSLocalizedDescriptionKey:@"应用当前版本较低，不支持此分享方式"}]);
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [handler shareWithShareModel:shareModel shareBlock:shareBlock];
            });
        }
    }else {
        if (shareBlock) {
            shareBlock(CMShareResultFailed, [NSError errorWithDomain:CMPlatformErrorDomain code:CMShareResultFailed userInfo:@{NSLocalizedDescriptionKey:@"未正确配置该平台，或该平台不支持分享"}]);
        }
    }
}

@end

