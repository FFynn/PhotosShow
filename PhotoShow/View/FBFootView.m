//
//  FBFootView.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "FBFootView.h"

const static NSInteger btnTag = 100;

@implementation FBFootView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.buttonView];
    }
    return self;
}

//  设置按钮视图
- (UIScrollView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
        _buttonView.bounces = NO;
        _buttonView.showsHorizontalScrollIndicator = NO;
        _buttonView.showsVerticalScrollIndicator = NO;
    }
    return _buttonView;
}

- (void)addFootViewButton {
    for (NSUInteger idx = 0; idx < self.titleArr.count; idx ++) {
        UIButton * toolBtn = [[UIButton alloc] initWithFrame:CGRectMake(idx * SCREEN_WIDTH/self.titleArr.count, 0, SCREEN_WIDTH/self.titleArr.count, 47)];
        [toolBtn setTitle:self.titleArr[idx] forState:(UIControlStateNormal)];
        [toolBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [toolBtn setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
        toolBtn.backgroundColor = [UIColor blackColor];
        toolBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        toolBtn.tag = btnTag + idx;
        
        if (toolBtn.tag == btnTag) {
            toolBtn.selected = YES;
            self.seletedBtn = toolBtn;
        }
        
        [toolBtn addTarget:self action:@selector(toolBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [self.buttonView addSubview:toolBtn];
    }
}

- (void)toolBtnClick:(UIButton *)button {
    self.seletedBtn.selected = NO;
    button.selected = YES;
    self.seletedBtn = button;
    
    //  改变导航条的位置
    CGRect lineRect = self.line.frame;
    lineRect.origin.x = (SCREEN_WIDTH/self.titleArr.count) * (button.tag - btnTag);
    [UIView animateWithDuration:.2 animations:^{
        self.line.frame = lineRect;
    }];
    
    if ([_delegate respondsToSelector:@selector(buttonDidSeletedWithIndex:)]) {
        [_delegate buttonDidSeletedWithIndex:(button.tag - btnTag)];
    }
    
}

//  设置导航条
- (void)showLineWithButton {
    self.line = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, SCREEN_WIDTH/self.titleArr.count, 2)];
    self.line.backgroundColor = [UIColor redColor];
    [self.buttonView addSubview:self.line];
}

@end
