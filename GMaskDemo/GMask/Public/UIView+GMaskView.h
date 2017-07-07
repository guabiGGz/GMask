//
//  UIView+UIMaskViewProtocol.h
//  SimpleWeather
//
//  Created by ksjr-zg on 16/10/14.
//  Copyright © 2017年 快刷金融. All rights reserved.
//

@import UIKit;
#import "GMaskAnimator.h"

@protocol GMaskViewProtocol <NSObject>

@optional

/**
 此接口返回自定义视图的动画方式
 */
- (GMaskViewAnimationTransition)maskViewAnimatorTransition;

@end


@interface UIView (GMaskView) <GMaskViewProtocol>

- (BOOL)isShowedInMask;

#pragma mark - 针对类动画方式统一使用【Class】
- (void)showMasking;

- (void)dismissMasking;

/*!
 *  @brief 针对遮罩层带点击事件
 *
 *  @param tapHandle 点击事件回调
 */
- (void)showMaskingWithTap:(void(^)(void))tapHandle;

#pragma mark - 特殊场景下,需要特定动画方式时使用【Instance】
- (void)showMasking:(GMaskViewAnimationTransition)transition;

- (void)showMasking:(GMaskViewAnimationTransition)transition tap:(void(^)(void))tapHandler;


#pragma mark - 样式定制
/*!
 *  @brief 是否展示导航条
 *
 *  @param showNav 默认覆盖不展示
 */
- (void)setMaskShowNav:(BOOL)showNav;

/*!
 *  @brief 是否展示Tabbar
 *
 *  @param showTabbar 默认覆盖不展示
 */
- (void)setMaskShowTabbar:(BOOL)showTabbar;


/*!
 *  @brief 蒙版层是否高斯模糊
 *
 *  @param maskEffetct 默认蒙版模糊效果
 */
- (void)setMaskEffect:(BOOL)maskEffetct;

/*!
 *  @brief 设置蒙版背景颜色
 *
 *  @param color 蒙版背景颜色
 */
- (void)setMaskBackgroundColor:(UIColor *)color;
- (void)setMaskBackgroundColor:(UIColor *)color alpha:(CGFloat)alpla;

@end





