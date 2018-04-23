//
//  CMPayOrderModel.h
//  CMThirdPartyPlatformManager_Example
//
//  Created by maitianer on 2018/4/23.
//  Copyright © 2018年 comma. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CMThirdPartyPlatformManager;

@interface CMPayOrderModel : NSObject<CMPlatformOrderModel>

@property (nonatomic, strong) NSString *sign;

@end

@interface CMWechatPayModel : CMPayOrderModel

@property (nonatomic, strong) NSString *partnerID;
@property (nonatomic, strong) NSString *prepayID;
@property (nonatomic, strong) NSString *noncestr;
@property (assign, nonatomic) UInt32   timeStamp;

@end
