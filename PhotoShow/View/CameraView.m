//
//  CameraView.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "CameraView.h"

@implementation CameraView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.cameraNavView];
        
    }
    return self;
}

#pragma mark - 顶部导航
- (UIView *)cameraNavView {
    if (!_cameraNavView) {
        _cameraNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _cameraNavView.backgroundColor = [UIColor blackColor];
        
        [_cameraNavView addSubview:self.cameraCancelBtn];
        [_cameraNavView addSubview:self.cameraTitlt];
    }
    return _cameraNavView;
}

#pragma mark - 取消按钮
- (UIButton *)cameraCancelBtn {
    if (!_cameraCancelBtn) {
        _cameraCancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [_cameraCancelBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:(UIControlStateNormal)];
        [_cameraCancelBtn addTarget:self action:@selector(cameraCancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cameraCancelBtn;
}

- (void)cameraCancelBtnClick {
    [self.VC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 页面标题
- (UILabel *)cameraTitlt {
    if (!_cameraTitlt) {
        _cameraTitlt = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 120, 50)];
        _cameraTitlt.textColor = [UIColor whiteColor];
        _cameraTitlt.textAlignment = NSTextAlignmentCenter;
        _cameraTitlt.text = @"拍照";
        _cameraTitlt.font = [UIFont systemFontOfSize:17];
    }
    return _cameraTitlt;
}
@end
