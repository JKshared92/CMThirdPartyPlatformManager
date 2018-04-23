//
//  CMPlatformShareProtocol.h
//  CMThirdPartyPlatformManager
//
//  Created by comma on 2018/1/15.
//  Copyright © 2017年 comma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPlatformDefine.h"
#import "CMPlatformHandlerProtocol.h"
#import "CMPlatformShareModel.h"

typedef void (^ShareBlock)(CMShareResult shareResult, NSError *error);

@protocol CMPlatformShareProtocol <CMPlatformHandlerProtocol>

@required

/**
 分享至第三方平台
 
 @param shareModel 分享的内容
 @param shareBlock 分享后的回调
 */
- (void)shareWithShareModel:(CMPlatformShareModel *)shareModel
                 shareBlock:(ShareBlock)shareBlock;


/**
 可分享的渠道

 @return 返回可分享的渠道
 */
- (NSArray<CMPlatformShareType> *)supportShareTypes;

@end
