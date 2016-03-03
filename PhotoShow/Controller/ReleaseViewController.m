//
//  ReleaseViewController.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "ReleaseViewController.h"

@interface ReleaseViewController ()

@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavViewUI];
}

- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:@"编辑完成"];
    self.navTitle.textColor = [UIColor blackColor];
    [self addBackButton];
    [self addDoneButton];
    
    //  Nav跟视图内容的分割线
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
    self.line.backgroundColor = [UIColor blackColor];
    [self.navView addSubview:self.line];
}

@end
