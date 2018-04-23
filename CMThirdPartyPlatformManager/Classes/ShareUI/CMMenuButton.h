//
//  CMMenuButton.h
//  Pods
//
//  Created by comma on 2018/2/1.
//

#import <UIKit/UIKit.h>
#import "CMMenuModel.h"

@interface CMMenuButton : UIButton

@property (strong, nonatomic) CMMenuModel *menuModel;

+ (instancetype)buttonWithMenuModel:(CMMenuModel *)menuModel;

@end
