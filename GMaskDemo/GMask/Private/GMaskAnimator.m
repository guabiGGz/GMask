//
//  KSMaskAnimator.m
//  SimpleWeather
//
//  Created by ksjr-zg on 16/10/14.
//  Copyright © 2017年 快刷金融. All rights reserved.
//

#import "GMaskAnimator.h"
#import "UIWindow+GMaskView.h"
#import "GMaskView.h"

@interface GMaskAnimator () {
  @protected
    CGAffineTransform _animationBefore;
}

@property (nonatomic, strong, readwrite) UIView *referenceView;

@property (nonatomic, assign) GMaskViewAnimationTransition transition;

@end

@implementation GMaskAnimator

- (instancetype)initWithReferenceView:(UIView *)view
                      transition:(GMaskViewAnimationTransition)transition {
    self = [super init];
    if (self) {
        _referenceView = view;
        _transition = transition;
    }
    return self;
}

- (void)changeTransition:(GMaskViewAnimationTransition)transition {
    self.transition = transition;
}

- (void)startShowAnimating {
 
    [self calculateTransform];
    
    _animationBefore = self.referenceView.transform;
    
    UIWindow *keyWindows = [UIApplication sharedApplication].delegate.window;
    GMaskView *maskView = [keyWindows g_maskView];
    
    [self executeAnimation:^{
        self.referenceView.transform = CGAffineTransformIdentity;
        maskView.alpha = 1.f;
    } completion:^{
        
    }];
    
}

- (void)startDismissAnimating {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    GMaskView *maskView = [keyWindow g_maskView];

    [self executeAnimation:^{
        self.referenceView.transform = _animationBefore;
        maskView.alpha = 0.f;
    } completion:^{
        [self.referenceView removeFromSuperview];
        if (maskView.isNeedRemoved) {
            [keyWindow removeAssociatedG_MaskView:maskView];
            [maskView removeFromSuperview];
        }
    }];
}

#pragma mark - Privated
- (void)calculateTransform {
    
    CGFloat HTranslation = CGRectGetWidth(self.referenceView.frame);
    CGFloat VTranslation = CGRectGetHeight(self.referenceView.frame);
    _animationBefore = CGAffineTransformIdentity;
    switch (self.transition) {
        case GMaskViewTransitionFlipFromLeft: {
            _animationBefore = CGAffineTransformMakeTranslation(-HTranslation, 0);
            break;
        }
        case GMaskViewTransitionFlipFromRight: {
            _animationBefore = CGAffineTransformMakeTranslation(HTranslation, 0);
            break;
        }
        case GMaskViewTransitionFlipFromTop: {
            _animationBefore = CGAffineTransformMakeTranslation(0, -VTranslation);
            break;
        }
        case GMaskViewTransitionFlipFromBottom: {
            _animationBefore = CGAffineTransformMakeTranslation(0, VTranslation);
            break;
        }
        case GMaskViewAnimationTransitionFromCenter: {
            _animationBefore = CGAffineTransformMakeScale(0.25, 0.25);
        }
        default:break;
    }
    
    self.referenceView.transform = _animationBefore;
    
}

- (void)executeAnimation:(void(^)(void))animation completion:(void(^)(void))completion {
    
    CGFloat duration = (self.duration ?: 1);
    [UIView animateWithDuration:duration
                          delay:0.1
                        options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionBeginFromCurrentState animations:^{
                            
                            (!animation) ?: animation();
                            
                        } completion:^(BOOL finished) {
                            
                            (!completion) ?: completion();
                            
                        }];
}

@end
