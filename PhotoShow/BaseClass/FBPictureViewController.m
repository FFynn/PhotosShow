//
//  FBPictureViewController.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "FBPictureViewController.h"

@interface FBPictureViewController ()

@end

@implementation FBPictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navView];
}

#pragma mark - 隐藏系统状态栏
//  iOS7.0以后
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - 添加控件
//  页面标题
- (void)addNavViewTitle:(NSString *)title {
    self.navTitle.text = title;
    [self.navView addSubview:self.navTitle];
}

//  继续下一步
- (void)addNextButton {
    [self.navView addSubview:self.nextBtn];
}

//  返回上一步
- (void)addBackButton {
    [self.navView addSubview:self.backBtn];
}

//  发布按钮
- (void)addDoneButton {
    [self.navView addSubview:self.doneBtn];
}

#pragma mark - 顶部滚动的导航
- (UIView *)navView {
    if (!_navView) {
        _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _navView.backgroundColor = [UIColor blackColor];
    }
    return _navView;
}

#pragma mark -  页面的标题
- (UILabel *)navTitle {
    if (!_navTitle) {
        _navTitle = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, (SCREEN_WIDTH - 100), 50)];
        _navTitle.font = [UIFont systemFontOfSize:17];
        _navTitle.textColor = [UIColor whiteColor];
        _navTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _navTitle;
}

#pragma mark - 继续下一步的执行事件
- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_nextBtn setTitle:@"下一步" forState:(UIControlStateNormal)];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];

    }
    return _nextBtn;
}

#pragma mark - 返回上一步的执行事件 
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:(UIControlStateNormal)];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _backBtn;
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 设置完成按钮
- (UIButton *)doneBtn {
    if (!_doneBtn) {
        _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 60), 0, 50, 50)];
        [_doneBtn setTitle:@"完成" forState:(UIControlStateNormal)];
        [_doneBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _doneBtn;
}


@end
