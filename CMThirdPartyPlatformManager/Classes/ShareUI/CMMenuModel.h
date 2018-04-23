//
//  CMMenuModel.h
//  Pods
//
//  Created by comma on 2018/2/1.
//

#import <Foundation/Foundation.h>

@interface CMMenuModel : NSObject

@property (copy  , nonatomic) NSString *imageName;

@property (copy  , nonatomic) NSString *title;

@property (nonatomic, weak) UIColor* transitionRenderingColor;

@property (strong, nonatomic) UIColor *textColor;

@property (nonatomic, readonly, retain) UIView* customView;

+ (instancetype)menuModelWithImageName:(NSString *)imageName
                                 title:(NSString *)title
                             textColot:(UIColor  *)textColor;

@end
