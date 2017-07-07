//
//  UIWindow+GMaskView.m
//  Test
//
//  Created by ksjr-zg on 16/10/14.
//  Copyright © 2017年 快刷金融. All rights reserved.
//

#import "UIWindow+GMaskView.h"
#import "GMaskView.h"
#import <objc/runtime.h>

@implementation UIWindow (GMaskView)

- (void)associatedG_MaskView:(GMaskView *)maskView {
    objc_setAssociatedObject(self, _cmd, maskView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GMaskView *)g_maskView {
    return objc_getAssociatedObject(self, NSSelectorFromString(@"associatedG_MaskView:"));
}

- (void)removeAssociatedG_MaskView:(GMaskView *)maskView {
    objc_removeAssociatedObjects(self);
}
@end
