//
//  FBPictureCollectionViewCell.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "FBPictureCollectionViewCell.h"

@implementation FBPictureCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return _imageView;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.imageView.layer.borderWidth = selected ? 3 : 0;
}

@end
