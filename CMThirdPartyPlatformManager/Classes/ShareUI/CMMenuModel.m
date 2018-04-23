//
//  CMMenuModel.m
//  Pods
//
//  Created by comma on 2018/2/1.
//

#import "CMMenuModel.h"

@implementation CMMenuModel

+ (instancetype)menuModelWithImageName:(NSString *)imageName title:(NSString *)title textColot:(UIColor *)textColor {
    return [[self alloc] initWithImageName:imageName title:title textColot:textColor];
}

- (instancetype)initWithImageName:(NSString *)imageName title:(NSString *)title textColot:(UIColor *)textColor{
    self = [super init];
    if (self) {
        [self defaultSetting];
        
        self.imageName      = imageName;
        self.title          = title;
        self.textColor      = textColor;
    }
    return self;
}

- (void)defaultSetting {
    
}

@end
