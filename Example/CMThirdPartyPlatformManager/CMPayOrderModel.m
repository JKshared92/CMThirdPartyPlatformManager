//
//  CMPayOrderModel.m
//  CMThirdPartyPlatformManager_Example
//
//  Created by maitianer on 2018/4/23.
//  Copyright © 2018年 comma. All rights reserved.
//

#import "CMPayOrderModel.h"

@implementation CMPayOrderModel

- (NSString *)platformOrderSign {
    return self.sign;
}

@end

@implementation CMWechatPayModel

- (NSString *)platformOrderPrepayID {
    return self.prepayID;
}

- (NSString *)platformOrderPartnerID {
    return self.partnerID;
}

- (NSString *)platformOrderNoncestr {
    return self.noncestr;
}

- (UInt32)platformOrderTimeStamp {
    return self.timeStamp;
}

@end
