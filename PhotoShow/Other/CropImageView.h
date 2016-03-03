//
//  CropImageView.h
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBMacro.h"

@class CropLayer;

@protocol CropImageViewDelegate <NSObject>

@required

- (void)show;

//  确保裁剪框在图片内部.

- (void)initializeImageViewSize;


//  图片移出裁剪框
- (CGPoint)handleBorderOverflow;


//  图片缩放小于裁剪框
- (CGRect)handleScaleOverflowWithPoint:(CGPoint)point;

@end

#pragma mark - 裁剪图片的视图

@interface CropImageView : UIView <CropImageViewDelegate>

@pro_strong UIImageView         *   cropImage;  //  需要裁剪的图片视图
@pro_strong CropLayer           *   cropGrid;   //  裁剪是的遮罩

@end


#pragma mark - 裁剪视图的遮罩

@interface CropLayer : CALayer

@pro_assign CGRect                  clipRect;   //  裁剪的范围
@pro_strong UIColor             *   bgColor;    //  背景颜色
@pro_strong UIColor             *   gridColor;  //  裁掉的范围格子

@end
