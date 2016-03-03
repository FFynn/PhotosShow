//
//  CropImageView.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "CropImageView.h"

@implementation CropImageView

#pragma mark - 初始化视图
//  图片
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.cropImage];
        [self.layer addSublayer:self.cropGrid];
        
    }
    return self;
}

//  遮罩
- (instancetype)initWithFrame:(CGRect)frame withCropGrid:(CropLayer *)cropGrid {
    self = [super initWithFrame:frame];
    if (self) {
        self.cropGrid = cropGrid;
        self.clipsToBounds = YES;
        
        [self addSubview:self.cropImage];
        [self.layer addSublayer:self.cropGrid];

    }
    return self;
}

#pragma mark - 懒加载
//  图片
- (UIImageView *)cropImage {
    if (!_cropImage) {
        _cropImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _cropImage.contentMode = UIViewContentModeScaleAspectFill;
        _cropImage.clipsToBounds = YES;
    }
    return _cropImage;
}

//  遮罩
- (CropLayer *)cropGrid {
    if (!_cropGrid) {
        _cropGrid = [[CropLayer alloc] init];
        _cropGrid.frame = self.bounds;
    }
    return _cropGrid;
}

#pragma mark - 辅助方法

//  给出高度求宽度
- (CGFloat)scaleFitHeight:(CGFloat)height {
    return (self.cropImage.frame.size.width / self.cropImage.frame.size.height) * height;
}

//  给出宽度求高度
- (CGFloat)scaleFitWidth:(CGFloat)width {
    return (self.cropImage.frame.size.height / self.cropImage.frame.size.width) * width;
}

#pragma mark - 代理方法

- (void)show {
    [self.cropGrid setNeedsDisplay];
}

//  确保clippingRect始终在图片内部
- (void)initializeImageViewSize {
    self.cropImage.frame = CGRectMake(0, 0, self.cropImage.image.size.width, self.cropImage.image.size.height);
    self.cropImage.center = self.center;
}

//  图片移出裁剪框的情况
- (CGPoint)handleBorderOverflow {
    CGPoint rightTop, leftBottom, newCenter;
    newCenter = self.cropImage.center;
    CGRect clippingRect = self.cropGrid.clipRect;
    UIView * view = self.cropImage;
    
    rightTop.x = clippingRect.origin.x + clippingRect.size.width - view.frame.size.width/2;
    rightTop.y = clippingRect.origin.y + clippingRect.size.height - view.frame.size.height/2;
    leftBottom.x = clippingRect.origin.x + view.frame.size.width/2;
    leftBottom.y = clippingRect.origin.y + view.frame.size.height/2;
    
    //图片中心点超出x方向的最大值和最小值
    if(view.center.x < rightTop.x) {
        newCenter.x = rightTop.x;
        
    } else if(view.center.x > leftBottom.x){
        newCenter.x = leftBottom.x;
    }
    
    //图片中心点超出y方向的最大值和最小值
    if(view.center.y < rightTop.y) {
        newCenter.y = rightTop.y;
        
    } else if(view.center.y > leftBottom.y){
        newCenter.y = leftBottom.y;
    }
    
    return newCenter;
}

//  图片缩放小于裁剪框的尺寸
- (CGRect)handleScaleOverflowWithPoint:(CGPoint)point {
    
    CGRect clippingRect = self.cropGrid.clipRect;
    UIView * view = self.cropImage;
    CGRect frame = view.frame;
    
    //  图片的尺寸小于裁剪框的尺寸
    if(view.frame.size.width <= view.frame.size.height && frame.size.width < clippingRect.size.width) {
        float scale = clippingRect.size.width / frame.size.width;
        CGFloat vectorX,vectorY;
        
        vectorX = (point.x - view.center.x)*scale;
        vectorY = (point.y - view.center.y)*scale;
        view.transform = CGAffineTransformScale(view.transform, scale, scale);
        
        [view setCenter:(CGPoint){(point.x - vectorX) , (point.y - vectorY)}];
    }
    if(view.frame.size.width > view.frame.size.height && frame.size.height < clippingRect.size.height) {
        float scale = clippingRect.size.height / frame.size.height;
        CGFloat vectorX,vectorY;
        
        vectorX = (point.x - view.center.x)*scale;
        vectorY = (point.y - view.center.y)*scale;
        view.transform = CGAffineTransformScale(view.transform, scale, scale);
        
        [view setCenter:(CGPoint){(point.x - vectorX) , (point.y - vectorY)}];
    }
    return view.frame;
}

@end



#pragma mark -

@implementation CropLayer

- (instancetype)initWithClipRect:(CGRect)clipRect {
    self = [super init];
    if (self) {
        self.clipRect = clipRect;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)context {
    CGRect rect = self.bounds;
    CGContextSetFillColorWithColor(context, self.bgColor.CGColor);
    CGContextFillRect(context, rect);
    
    CGContextClearRect(context, self.clipRect);
    
    CGContextSetStrokeColorWithColor(context, self.gridColor.CGColor);
    CGContextSetLineWidth(context, 1);
    
    rect = self.clipRect;
    
    CGContextBeginPath(context);

    CGContextAddRect(context, self.clipRect);
    
    CGContextStrokePath(context);
}

#pragma mark - 懒加载
//  背景色
- (UIColor *)bgColor {
    if (!_bgColor) {
        _bgColor = [UIColor colorWithWhite:0 alpha:0.6];
    }
    return _bgColor;
}

//  裁掉的范围颜色
- (UIColor *)gridColor {
    if (!_gridColor) {
        _gridColor = [UIColor colorWithWhite:1 alpha:0.8];
    }
    return _gridColor;
}

//  范围
- (CGRect)clipRect {
    if (_clipRect.size.width == 0 && _clipRect.size.height == 0) {
        
    }
    return _clipRect;
}


@end
