//
//  ViewController.m
//  GMaskDemo
//
//  Created by kszg on 2017/4/14.
//  Copyright © 2017年 快刷金融. All rights reserved.
//

#import "ViewController.h"
#import "UIView+GMaskView.h"


@interface ViewController ()
@property (nonatomic, strong) UIView  *testView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.backgroundColor = [UIColor cyanColor];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.center = self.view.center;
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    //[view setMaskEffect:YES];
    [view setMaskBackgroundColor:[UIColor purpleColor] alpha:0.3];
    view.backgroundColor = [UIColor greenColor];
    self.testView = view;
    
   
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)click:(UIButton *)sender {
    [self.testView isShowedInMask] ?  [self.testView dismissMasking]
                                   :  [self.testView showMasking:GMaskViewTransitionFlipFromTop tap:^{
                                      [self.testView dismissMasking];
                                   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
