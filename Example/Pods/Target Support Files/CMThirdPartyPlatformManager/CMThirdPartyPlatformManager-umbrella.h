#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "AlipayHandler.h"
#import "CMPlatformDefine.h"
#import "CMPlatformHandler.h"
#import "CMPlatformHandlerProtocol.h"
#import "CMPlatformLoginProtocol.h"
#import "CMPlatformManager.h"
#import "CMPlatformOrderModel.h"
#import "CMPlatformPayProtocol.h"
#import "CMPlatformShareModel.h"
#import "CMPlatformShareProtocol.h"
#import "QQHandler.h"
#import "CMMenuButton.h"
#import "CMMenuModel.h"
#import "CMShareMenuView.h"
#import "WechatHandler.h"
#import "WechatAuthSDK.h"
#import "WXApi.h"
#import "WXApiObject.h"

FOUNDATION_EXPORT double CMThirdPartyPlatformManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char CMThirdPartyPlatformManagerVersionString[];

