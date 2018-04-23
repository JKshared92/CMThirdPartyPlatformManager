//
//  CMShareMenuView.h
//  Pods
//
//  Created by comma on 2018/2/1.
//

#import <UIKit/UIKit.h>
#import "CMMenuModel.h"

typedef NS_ENUM(NSInteger, CMShareMenuViewBackgroundType) {
    CMShareMenuViewBackgroundTypeLightBlur         = 0, //light模糊背景类型
    CMShareMenuViewBackgroundTypeDarkBlur          = 1, //dark模糊背景类型
};

typedef NS_ENUM(NSInteger, CMShareMenuViewAnimationType) {
    CMShareMenuViewAnimationTypeSina           = 0, //仿新浪微博的弹出动画
    CMShareMenuViewAnimationTypeViscous        = 1, //带有粘性的动画
    CMShareMenuViewAnimationTypeCenter         = 2, //底部中心点弹出动画
    CMShareMenuViewAnimationTypeLeftAndRight   = 3, //左右弹出动画

};

@interface CMShareMenuView : UIView


@property (copy  , nonatomic, readonly) NSArray<CMMenuModel *> *dataSource;

/** 背景类型，默认为 CMShareMenuViewBackgroundTypeLightBlur */
@property (assign, nonatomic) CMShareMenuViewBackgroundType backgroundType;

/** 动画类型，默认为 CMShareMenuViewAnimationTypeSina */
@property (assign, nonatomic) CMShareMenuViewAnimationType animationType;

/** 动画的速度，默认为 10.0f，取值范围: 0.0f ~ 20.0f */
@property (assign, nonatomic) CGFloat popMenuSpeed;



/**
 添加一个菜单对象

 @param menuModel 菜单对象
 */
- (void)addMenuModel:(CMMenuModel *)menuModel;


/**
 添加一组菜单对象

 @param menuModels 一组菜单对象
 */
- (void)addMenuModels:(NSArray <CMMenuModel *> *)menuModels;


/**
 弹出分享界面
 */
- (void)show;


/**
 隐藏分享界面
 */
- (void)hide;

@end
