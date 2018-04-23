//
//  QQHandler.h
//  Pods
//
//  Created by comma on 2018/1/27.
//

#import "CMPlatformHandler.h"

/***
 QQ登录文档：http://wiki.open.qq.com/wiki/QQ用户能力

 QQ分享文档：http://wiki.open.qq.com/wiki/QQ用户能力
 */

//平台标识
FOUNDATION_EXPORT CMPlatformIdentifier const PlatformIdentifierQQ;

//支持的分享方式
FOUNDATION_EXPORT CMPlatformShareType  const PlatformShareTypeQQSession;
FOUNDATION_EXPORT CMPlatformShareType  const PlatformShareTypeQQZone;


@interface QQHandler : CMPlatformHandler<CMPlatformLoginProtocol,CMPlatformShareProtocol>

- (instancetype)initWithAppID:(NSString *)appID;

@end
