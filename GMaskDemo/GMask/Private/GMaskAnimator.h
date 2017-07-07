//
//  KSMaskAnimator.h
//  SimpleWeather
//
//  Created by ksjr-zg on 16/10/14.
//  Copyright © 2017年 快刷金融. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef NS_ENUM(NSInteger, GMaskViewAnimationTransition) {
    GMaskViewAnimationTransitionNone,
    GMaskViewTransitionFlipFromLeft,
    GMaskViewTransitionFlipFromRight,
    GMaskViewTransitionFlipFromTop,
    GMaskViewTransitionFlipFromBottom,
    GMaskViewAnimationTransitionFromCenter
};

@interface GMaskAnimator : NSObject

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, strong, readonly) UIView *referenceView;

- (instancetype)initWithReferenceView:(UIView *)view
                           transition:(GMaskViewAnimationTransition)transition;

- (void)startShowAnimating;

- (void)startDismissAnimating;

- (void)changeTransition:(GMaskViewAnimationTransition)transition;

@end
