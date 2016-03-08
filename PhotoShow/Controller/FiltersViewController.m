//
//  FiltersViewController.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "FiltersViewController.h"
#import "ReleaseViewController.h"
#import "FBFilters.h"

@interface FiltersViewController () <FBFootViewDelegate>

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setFiltersControllerUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFilter:) name:@"fitlerName" object:nil];
}

- (void)changeFilter:(NSNotification *)filterName {
    UIImage * showFilterImage = [[FBFilters alloc] initWithImage:self.filtersImg filterName:[filterName object]].filterImg;
    self.filtersImageView.image = showFilterImage;
}

#pragma mark - 设置顶部导航栏
- (void)setNavViewUI {
    [self addNavViewTitle:@"工具"];
    [self addBackButton];
    [self addNextButton];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    
}

#pragma mark 继续按钮的点击事件
- (void)nextBtnClick {
    ReleaseViewController * releaseVC = [[ReleaseViewController alloc] init];
    releaseVC.doneImageView.image = self.filtersImageView.image;
    [self.navigationController pushViewController:releaseVC animated:YES];
}

#pragma mark - 设置视图UI
- (void)setFiltersControllerUI {
    
    [self setNavViewUI];
    
    self.filtersImageView.image = self.filtersImg;
    [self.view addSubview:self.filtersImageView];
    
    [self.view addSubview:self.footView];
}

#pragma mark - 底部的工具栏
- (FBFootView *)footView {
    if (!_footView) {
        _footView = [[FBFootView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        NSArray * titleArr = [[NSArray alloc] initWithObjects:@"工具",@"调整",@"贴纸",@"滤镜", nil];
        _footView.backgroundColor = [UIColor blackColor];
        _footView.titleArr = titleArr;
        [_footView addFootViewButton];
        _footView.delegate = self;
    }
    return _footView;
}

- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    if (index == 3) {
        [self.view addSubview:self.filtersView];
    
    } else {
        NSLog(@"打开视图＝＝＝ %zi", index);
        [self.filtersView removeFromSuperview];
    }
}

#pragma mark - 处理图片的视图
- (UIImageView *)filtersImageView {
    if (!_filtersImageView) {
        _filtersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_WIDTH)];
    }
    return _filtersImageView;
}

#pragma mark - 滤镜视图
- (FiltersView *)filtersView {
    if (!_filtersView) {
        _filtersView = [[FiltersView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 170, SCREEN_WIDTH, 120)];
    }
    return _filtersView;
}


@end
