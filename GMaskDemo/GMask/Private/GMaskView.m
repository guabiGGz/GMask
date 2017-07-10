//
//  KSMaskView.m
//  SimpleWeather
//
//  Created by ksjr-zg on 16/10/14.
//  Copyright © 2016年 Ryan Nystrom. All rights reserved.
//

#import "GMaskView.h"
#import "GMaskAnimator.h"
#import "UIImage+ImageEffects.h"

@interface GMaskView ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign, readwrite) BOOL showing;

@property (nonatomic, assign, readwrite) BOOL needRemoved;

@property (nonatomic, strong) GMaskAnimator *animator;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, copy) void(^tapHandle)(void);

@end

@implementation GMaskView
#pragma mark - Constuctor
- (instancetype)initWithAnimator:(GMaskAnimator *)animator {
    self = [self init];
    if (self) {
        _animator = animator;
        [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.userInteractionEnabled = YES;
        self.needRemoved = NO;
        self.alpha = 0;
        self.showNav = NO;
        self.showTabbar = NO;
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
        self.tap.delegate = self;
        [self addGestureRecognizer:self.tap];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = [UIScreen mainScreen].bounds;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"bounds"];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"bounds"]) {
        _needRemoved = YES;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Action
- (void)show {
    self.tap.enabled = NO;
    [self showWithComplete:nil];
}

- (void)showWithTapHandle:(void(^)(void))tap {
    self.tap.enabled = YES;
    [self showWithComplete:tap];
}

- (void)dismiss {
    if (nil == self)    return;
    if (!self.isShowing) return;
    
    [self.animator startDismissAnimating];
    _showing = NO;
}

- (void)setAnimatorTransition:(GMaskViewAnimationTransition)transition {
    [self.animator changeTransition:transition];
}

#pragma mark - System Delegate
#pragma mark - Gesture Delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self];
    if (CGRectContainsPoint(self.animator.referenceView.frame, point)) {
        return NO;
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

#pragma mark - Statue
- (BOOL)isShowing {
    if (!self)  return NO;
    if (0.f == self.alpha)  return NO;
    return _showing;
}

- (BOOL)isNeedRemoved {
    return _needRemoved;
}

#pragma mark - Event
- (void)tapEvent:(UIGestureRecognizer *)gesture {
    !(self.tapHandle) ?: self.tapHandle();
    [self dismiss];
}

#pragma mark - Private
- (void)showWithComplete:(void(^)(void))complete {
    if (nil == self)            return;
    if (nil == self.animator)   return;
    if (self.isShowing)         return;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    [self reCalculateFrame];
    [keyWindow addSubview:self];
    
    self.animator.referenceView.center = self.center;
    
    [self applyBlurImageOnWindow:keyWindow
                      blurRadius:10
                       tintColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]
           saturationDeltaFactor:1.0
                        complete:^(UIImage *blurImage) {
                            self.image = blurImage;
                            [self.animator startShowAnimating];
                            _showing = YES;
                            _tapHandle = complete;
                        }];
}

- (void)reCalculateFrame {
    CGRect bounds = self.bounds;
    CGPoint center = self.center;
    if (self.showNav) {
        bounds.origin.y += 64;
        bounds.size.height -= 64;
        center.y += 32;
    }
    if (self.showTabbar) {
        bounds.size.height -= 49;
        center.y -= 24.5;
    }
    self.bounds = bounds;
    self.center = center;
    [self addSubview:self.animator.referenceView];
}

- (void)applyBlurImageOnWindow:(UIWindow *)window
                    blurRadius:(CGFloat)blurRadius
                     tintColor:(UIColor *)tintColor
         saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                      complete:(void(^)(UIImage *blurImage))complete{
    
    UIView *view = [self getCurrentVCOnWindow:window].view;
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *applyedImage = [image applyBlurWithRadius:blurRadius
                                                 tintColor:tintColor
                                     saturationDeltaFactor:saturationDeltaFactor
                                                 maskImage:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            (!complete) ?: complete(applyedImage);
        });
    });
}

- (UIViewController *)getCurrentVCOnWindow:(UIWindow *)window {
    UIViewController *result = nil;
    id  nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
        
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabbar = (UITabBarController *)nextResponder;
        UINavigationController *nav = tabbar.selectedViewController;
        result = nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]) {
        UIViewController *nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
        
    }else{
        result = nextResponder;
    }
    
    return result;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
