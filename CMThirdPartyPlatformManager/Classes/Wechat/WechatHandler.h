//
//  WechatHandler.h
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/16.
//  Copyright © 2017年 comma. All rights reserved.
//

#import "CMPlatformHandler.h"

/***
    微信登录文档：https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317851&token=&lang=zh_CN
 
    微信支付文档：https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317780&token=&lang=zh_CN
 
    微信分享文档：https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317332&token=&lang=zh_CN
*/

//平台标识
FOUNDATION_EXPORT CMPlatformIdentifier const PlatformIdentifierWechat;

//支持的分享方式
FOUNDATION_EXPORT CMPlatformShareType  const PlatformShareTypeWechatSession;
FOUNDATION_EXPORT CMPlatformShareType  const PlatformShareTypeWechatTimeLine;
FOUNDATION_EXPORT CMPlatformShareType  const PlatformShareTypeWechatFavorite;


@interface WechatHandler : CMPlatformHandler<CMPlatformLoginProtocol,CMPlatformPayProtocol,CMPlatformShareProtocol>

- (instancetype)initWithAppID:(NSString *)appID
                    appSecret:(NSString *)appSecret
                    appScheme:(NSString *)appScheme;

@end
