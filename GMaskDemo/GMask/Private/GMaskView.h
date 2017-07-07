//
//  KSMaskView.h
//  SimpleWeather
//
//  Created by ksjr-zg on 16/10/14.
//  Copyright © 2017年 快刷金融. All rights reserved.
//

@import UIKit;
#import "GMaskAnimator.h"

@interface GMaskView : UIImageView

@property (nonatomic, assign, readonly, getter=isShowing) BOOL showing;

@property (nonatomic, assign, readonly, getter=isNeedRemoved) BOOL needRemoved;

@property (nonatomic, assign) BOOL showNav;

@property (nonatomic, assign) BOOL showTabbar;

@property (nonatomic, assign) BOOL effect;

- (instancetype)initWithAnimator:(GMaskAnimator *)animator;

- (void)show;

- (void)showWithTap:(void(^)(void))tapHandler;

- (void)dismiss;

- (void)setAnimatorTransition:(GMaskViewAnimationTransition)transition;

@end


