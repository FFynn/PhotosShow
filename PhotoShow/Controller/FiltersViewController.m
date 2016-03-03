//
//  FiltersViewController.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "FiltersViewController.h"
#import "ReleaseViewController.h"

@interface FiltersViewController ()

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setNavViewUI];
    
    self.filtersImageView.image = self.filtersImg;
    [self.view addSubview:self.filtersImageView];
}

- (void)setNavViewUI {
    [self addNavViewTitle:@"工具"];
    [self addBackButton];
    [self addNextButton];
    [self.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:(UIControlEventTouchUpInside)];

}

- (void)nextBtnClick {
    ReleaseViewController * releaseVC = [[ReleaseViewController alloc] init];
    [self.navigationController pushViewController:releaseVC animated:YES];
}


- (UIImageView *)filtersImageView {
    if (!_filtersImageView) {
        _filtersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 50, (SCREEN_WIDTH - 60), (SCREEN_HEIGHT - 100))];
        
    }
    return _filtersImageView;
}

@end
