//
//  FBFiltersCollectionViewCell.m
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FBFiltersCollectionViewCell.h"

@implementation FBFiltersCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.filtersImageView];
        
        [self addSubview:self.filtersTitle];
    }
    return self;
}

#pragma mark - 滤镜图
- (UIImageView *)filtersImageView {
    if (!_filtersImageView) {
        _filtersImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 15, 70, 70)];
        _filtersImageView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _filtersImageView;
}

#pragma mark 选中的状态
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.filtersImageView.layer.borderWidth = selected ? 2 : 0;
    self.filtersTitle.textColor = [UIColor redColor];
    
    if (selected == NO) {
        self.filtersTitle.textColor = [UIColor whiteColor];
    }
}

#pragma mark - 滤镜标题
- (UILabel *)filtersTitle {
    if (!_filtersTitle) {
        _filtersTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 70, 70)];
        _filtersTitle.font = [UIFont systemFontOfSize:13];
        _filtersTitle.textColor = [UIColor whiteColor];
        _filtersTitle.textAlignment = NSTextAlignmentCenter;
        
    }
    return _filtersTitle;
}


@end
