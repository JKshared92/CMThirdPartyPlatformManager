//
//  CMShareMenuView.m
//  Pods
//
//  Created by comma on 2018/2/1.
//

#import "CMShareMenuView.h"
#import "CMMenuButton.h"
#import <Masonry/Masonry.h>
#import <pop/pop.h>

@interface CMShareMenuView ()

@property (weak  , nonatomic) UIView               *superView;
@property (strong, nonatomic) UIVisualEffectView   *effectBackgroundView;
@property (strong, nonatomic) UIView               *bottomView;

@property (strong, nonatomic) NSMutableArray       *menuModels;

@end

@implementation CMShareMenuView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaultSetting];
    }
    return self;
}

- (void)defaultSetting {
    [self setFrame:[UIScreen mainScreen].bounds];
    self.backgroundType = CMShareMenuViewBackgroundTypeLightBlur;
    self.popMenuSpeed = 10.f;
}

- (void)addMenuModel:(CMMenuModel *)menuModel {
    [self.menuModels addObject:menuModel];
}

- (void)addMenuModels:(NSArray<CMMenuModel *> *)menuModels {
    [self.menuModels addObjectsFromArray:menuModels];
}


- (void)show {
    [[self mainWindow] addSubview:self];
    [self showBackgroundAnimate];
    [self showMenuAnimate];
}

- (void)hide {
    
}

- (void)addBackgroundView {
    self.effectBackgroundView = [[UIVisualEffectView alloc] initWithEffect:nil];
    [self addSubview:self.effectBackgroundView];
    [self.effectBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)addCloseButton {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.adjustsImageWhenHighlighted = NO;
    [self.effectBackgroundView.contentView addSubview:closeButton];
    [closeButton addTarget:self action:@selector(closeMenu) forControlEvents:UIControlEventTouchUpInside];
    [closeButton sizeToFit];
    [self.effectBackgroundView.contentView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.effectBackgroundView.contentView);
        make.bottom.equalTo(self.effectBackgroundView.contentView).with.offset(15);
    }];
}

- (void)showBackgroundAnimate {
    [self addBackgroundView];
    [self addCloseButton];
    
    [UIView animateWithDuration:0.5 animations:^{
        switch (self.backgroundType) {
            case CMShareMenuViewBackgroundTypeLightBlur:
                self.effectBackgroundView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
                break;
            case CMShareMenuViewBackgroundTypeDarkBlur:
                self.effectBackgroundView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
                break;
        }
        //self.close.transform = CGAffineTransformMakeRotation((M_PI / 2) / 2);
    }];
}

- (void)showMenuAnimate {
    __weak __typeof(self)weakSelf = self;
    [self.menuModels enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        CMMenuModel *model = obj;
        CMMenuButton *menuButton = [CMMenuButton buttonWithMenuModel:model];
        [menuButton addTarget:self action:@selector(selectedFunc:) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.effectBackgroundView.contentView addSubview:menuButton];
        
        CGRect toRect;
        CGRect fromRect;
        CGFloat screenWidth  = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CFTimeInterval delay = idx * 0.035f + CACurrentMediaTime();
        
        switch (self.animationType) {
            case CMShareMenuViewAnimationTypeSina:
                toRect = [weakSelf getFrameAtIndex:idx];
                fromRect = CGRectMake(CGRectGetMinX(toRect),
                                      CGRectGetMinY(toRect) + 130,
                                      toRect.size.width,
                                      toRect.size.height);
                break;
            case CMShareMenuViewAnimationTypeCenter:
                toRect = [weakSelf getFrameAtIndex:idx];
                fromRect = CGRectMake(CGRectGetMidX(weakSelf.frame) - fromRect.size.width / 2,
                                      (CGRectGetMinY(toRect) + (screenHeight - CGRectGetMinY(toRect))) - 25,
                                      toRect.size.width,
                                      toRect.size.height);
                break;
            case CMShareMenuViewAnimationTypeViscous:
                toRect = [weakSelf getFrameAtIndex:idx];
                fromRect = CGRectMake(CGRectGetMinX(toRect),
                                      CGRectGetMinY(toRect) + (screenHeight - CGRectGetMinY(toRect)),
                                      toRect.size.width,
                                      toRect.size.height);
                break;
            case CMShareMenuViewAnimationTypeLeftAndRight:
                toRect = [weakSelf getFrameAtIndex:idx];
                CGFloat d = (idx % 2) == 0 ? 0:CGRectGetWidth(toRect);
                CGFloat x = ((idx % 2) * screenWidth) - d;
                fromRect = CGRectMake(x,
                                      CGRectGetMinY(toRect) + (screenHeight - CGRectGetMinY(toRect)),
                                      toRect.size.width,
                                      toRect.size.height);
                break;
        }
        
        [weakSelf addAnimationToButton:menuButton withfromRect:fromRect toRect:toRect deleay:delay hideDisplay:NO];
    
    }];
}

- (CGRect)getFrameAtIndex:(NSUInteger)index {
    NSInteger column = 3; //一行最多3个
    CGFloat buttonViewWidth = MIN(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) / column;
    CGFloat buttonViewHeight = (buttonViewWidth - 10);
    CGFloat margin = (self.frame.size.width - column * buttonViewWidth) / (column + 1);
    NSInteger colnumIndex = index % column;
    NSInteger rowIndex = index / column;
    NSUInteger toRows = (_dataSource.count / column) + ((_dataSource.count % column) ? 1 : 0);
    
    CGFloat toHeight = toRows * buttonViewHeight;
    CGFloat buttonViewX = (colnumIndex + 1) * margin + colnumIndex * buttonViewWidth;
    CGFloat buttonViewY = ((rowIndex + 1) * margin + rowIndex * buttonViewHeight) + ([UIScreen mainScreen].bounds.size.height - toHeight) - 150;
    CGRect rect = CGRectMake(buttonViewX, buttonViewY, buttonViewWidth, buttonViewHeight);
    return rect;
}

- (void)addAnimationToButton:(CMMenuButton *)menuButton
                withfromRect:(CGRect)fromRect
                      toRect:(CGRect)toRect
                      deleay:(CFTimeInterval)deleay
                 hideDisplay:(BOOL)hideDisplay {
    switch (self.animationType) {
        case CMShareMenuViewAnimationTypeSina:
            [self startSinaAnimationOnMenuButton:menuButton fromValue:fromRect toValue:toRect delay:deleay hideDisplay:hideDisplay];
            break;
        case CMShareMenuViewAnimationTypeViscous:
            [self startViscousAnimationOnMenuButton:menuButton fromValue:fromRect toValue:toRect delay:deleay hideDisplay:hideDisplay];
            break;
        case CMShareMenuViewAnimationTypeCenter:
             [self startSinaAnimationOnMenuButton:menuButton fromValue:fromRect toValue:toRect delay:deleay hideDisplay:hideDisplay];
            break;
        case CMShareMenuViewAnimationTypeLeftAndRight:
            [self startViscousAnimationOnMenuButton:menuButton fromValue:fromRect toValue:toRect delay:deleay hideDisplay:hideDisplay];
            break;
        default:
            break;
    }
}

#pragma mark - Animation
- (void)startViscousAnimationOnMenuButton:(CMMenuButton *)menuButton
                                fromValue:(CGRect)fromValue
                                  toValue:(CGRect)toValue
                                    delay:(CFTimeInterval)delay
                              hideDisplay:(BOOL)hideDisplay {
    CGFloat toV, fromV;
    CGFloat springBounciness = 8.f;
    toV = !hideDisplay;
    fromV = hideDisplay;
    
    if (hideDisplay) {
        POPBasicAnimation *basicAnimationCenter = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        basicAnimationCenter.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        basicAnimationCenter.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        basicAnimationCenter.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        basicAnimationCenter.beginTime = delay;
        basicAnimationCenter.duration = 0.18;
        [menuButton pop_addAnimation:basicAnimationCenter forKey:basicAnimationCenter.name];
        
        POPBasicAnimation *basicAnimationScale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleX];
        basicAnimationScale.removedOnCompletion = YES;
        basicAnimationScale.beginTime = delay;
        basicAnimationScale.toValue = @(0.7);
        basicAnimationScale.fromValue = @(1);
        basicAnimationScale.duration = 0.18;
        basicAnimationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [menuButton.layer pop_addAnimation:basicAnimationScale forKey:basicAnimationScale.name];
    }
    else {
        POPSpringAnimation *basicAnimationCenter = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        basicAnimationCenter.beginTime = delay;
        basicAnimationCenter.springSpeed = _popMenuSpeed;
        basicAnimationCenter.springBounciness = springBounciness;
        basicAnimationCenter.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        basicAnimationCenter.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        
        POPBasicAnimation *basicAnimationScale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleX];
        basicAnimationScale.beginTime = delay;
        basicAnimationScale.toValue = @(1);
        basicAnimationScale.fromValue = @(0.7);
        basicAnimationScale.duration = 0.3f;
        basicAnimationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [menuButton.layer pop_addAnimation:basicAnimationScale forKey:basicAnimationScale.name];
        
        POPBasicAnimation *basicAnimationAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        basicAnimationAlpha.removedOnCompletion = YES;
        basicAnimationAlpha.duration = 0.1f;
        basicAnimationAlpha.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        basicAnimationAlpha.beginTime = delay;
        basicAnimationAlpha.toValue = @(toV);
        basicAnimationAlpha.fromValue = @(fromV);
        
        [menuButton pop_addAnimation:basicAnimationAlpha forKey:basicAnimationAlpha.name];
        [menuButton pop_addAnimation:basicAnimationCenter forKey:basicAnimationCenter.name];
    }
}

- (void)startSinaAnimationOnMenuButton:(CMMenuButton *)menuButton
                             fromValue:(CGRect)fromValue
                               toValue:(CGRect)toValue
                                 delay:(CFTimeInterval)delay
                           hideDisplay:(BOOL)hideDisplay {
    
    CGFloat toV, fromV;
    CGFloat springBounciness = 10.f;
    toV = !hideDisplay;
    fromV = hideDisplay;
    
    if (hideDisplay) {
        POPBasicAnimation* basicAnimationCenter = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        basicAnimationCenter.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        basicAnimationCenter.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        basicAnimationCenter.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        basicAnimationCenter.beginTime = delay;
        basicAnimationCenter.duration = 0.18;
        [menuButton pop_addAnimation:basicAnimationCenter forKey:basicAnimationCenter.name];
        
        POPBasicAnimation* basicAnimationScale = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
        basicAnimationScale.removedOnCompletion = YES;
        basicAnimationScale.beginTime = delay;
        basicAnimationScale.toValue = [NSValue valueWithCGPoint:CGPointMake(0.7, 0.7)];
        basicAnimationScale.fromValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        basicAnimationScale.duration = 0.18;
        basicAnimationScale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [menuButton.layer pop_addAnimation:basicAnimationScale forKey:basicAnimationScale.name];
    }
    else {
        POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        springAnimation.removedOnCompletion = YES;
        springAnimation.beginTime = delay;
        springAnimation.springBounciness = springBounciness; // value between 0-20
        springAnimation.springSpeed = _popMenuSpeed; // value between 0-20
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(toValue), CGRectGetMidY(toValue))];
        springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(fromValue), CGRectGetMidY(fromValue))];
        
        POPBasicAnimation* basicAnimationAlpha = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        basicAnimationAlpha.removedOnCompletion = YES;
        basicAnimationAlpha.duration = 0.2;
        basicAnimationAlpha.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        basicAnimationAlpha.beginTime = delay;
        basicAnimationAlpha.toValue = @(toV);
        basicAnimationAlpha.fromValue = @(fromV);
        [menuButton pop_addAnimation:basicAnimationAlpha forKey:basicAnimationAlpha.name];
        [menuButton pop_addAnimation:springAnimation forKey:springAnimation.name];
    }
}

#pragma mark - Setter && Getter
- (UIWindow *)mainWindow {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window == nil)
        window = [[[UIApplication sharedApplication] delegate] window];
    return window;
}

@end
