//
//  UIView+UIMaskViewProtocol.m
//  SimpleWeather
//
//  Created by ksjr-zg on 16/10/14.
//  Copyright © 2017年 快刷金融. All rights reserved.
//

#import "UIView+GMaskView.h"
#import "GMaskView.h"
#import "GMaskAnimator.h"
#import "UIWindow+GMaskView.h"
#import <objc/runtime.h>

@implementation UIView (UIMaskView)


- (void)showMasking {
    [[self g_maskView] show];
}

- (void)showMaskingWithTap:(void(^)(void))tapHandler {
    [[self g_maskView] showWithTap:tapHandler];
}

- (BOOL)isShowedInMask {
    if (![self g_maskView]) {
        return NO;
    }
    return [[self g_maskView] isShowing];
}

- (void)showMasking:(GMaskViewAnimationTransition)transition {
    GMaskView *maskView = [self g_maskView];
    [maskView setAnimatorTransition:transition];
    [maskView show];
}

- (void)showMasking:(GMaskViewAnimationTransition)transition tap:(void(^)(void))tapHandler {
    GMaskView *maskView = [self g_maskView];
    [maskView setAnimatorTransition:transition];
    [maskView showWithTap:tapHandler];
}

- (void)dismissMasking {
    [[self g_maskView] dismiss];
}

- (void)setMaskShowNav:(BOOL)showNav {
    [self g_maskView].showNav = showNav;
}

- (void)setMaskShowTabbar:(BOOL)showTabbar {
    [self g_maskView].showTabbar = showTabbar;
}

- (void)setMaskEffect:(BOOL)maskEffetct {
    [self g_maskView].effect = maskEffetct;
}

- (void)setMaskBackgroundColor:(UIColor *)color {
    [self g_maskView].backgroundColor = [color colorWithAlphaComponent:1];
}

- (void)setMaskBackgroundColor:(UIColor *)color alpha:(CGFloat)alpla {
    [self g_maskView].backgroundColor = [color colorWithAlphaComponent:alpla];
}

#pragma mark - Private
- (GMaskView *)g_maskView {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    GMaskView *maskView = [keyWindow g_maskView];
    
    if (!maskView) {
        GMaskViewAnimationTransition transition = GMaskViewAnimationTransitionFromCenter;
        if ([self respondsToSelector:@selector(maskViewAnimatorTransition)]) {
            transition = [self maskViewAnimatorTransition];
        }
        GMaskAnimator *maskAnimator = [[GMaskAnimator alloc] initWithReferenceView:self
                                                                        transition:transition];
        
        maskView = [[GMaskView alloc] initWithAnimator:maskAnimator];
        [keyWindow associatedG_MaskView:maskView];
    }
    return maskView;
}
@end




