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
    
    [self.view addSubview:self.doneImageView];
    
    [self.view addSubview:self.saveBtn];
}

- (void)setNavViewUI {
    self.navView.backgroundColor = [UIColor whiteColor];
    [self addNavViewTitle:@"编辑完成"];
    self.navTitle.textColor = [UIColor blackColor];
    [self addBackButton];
}

#pragma mark - 编辑完成的图片
- (UIImageView *)doneImageView {
    if (!_doneImageView) {
        _doneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH/4, SCREEN_WIDTH, SCREEN_WIDTH)];
    }
    return _doneImageView;
}

#pragma mark - 保存图片按钮
- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100, SCREEN_HEIGHT * 0.8, 200, 50)];
        [_saveBtn setTitle:@"保存到相册" forState:(UIControlStateNormal)];
        _saveBtn.backgroundColor = [UIColor redColor];
        _saveBtn.layer.cornerRadius = 10;
        _saveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
    return _saveBtn;
}
@end
