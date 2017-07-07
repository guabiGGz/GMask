//
//  UIWindow+GMaskView.h
//  Test
//
//  Created by ksjr-zg on 16/10/14.
//  Copyright © 2016年 ksjr. All rights reserved.
//

@import UIKit;
@class GMaskView;

@interface UIWindow (GMaskView)

- (void)associatedG_MaskView:(GMaskView *)maskView;

- (GMaskView *)g_maskView;

- (void)removeAssociatedG_MaskView:(GMaskView *)maskView;
@end
