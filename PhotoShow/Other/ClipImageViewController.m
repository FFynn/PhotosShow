//
//  ClipImageViewController.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "ClipImageViewController.h"

#import "CropImageView.h"

@interface ClipImageViewController () <UIGestureRecognizerDelegate>

@pro_assign CGFloat scale;
@pro_assign CGFloat rotaion;
@pro_assign CGPoint centerPoint;
@pro_assign CGPoint touchPoint;

@end

@implementation ClipImageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 将图片缩放至裁剪框的边缘
    CGRect squareFrame = self.clipImageView.cropGrid.clipRect;
    CGFloat length = MIN(squareFrame.size.height , squareFrame.size.width);
    CGFloat imageLength = MIN(self.clipImage.size.width, self.clipImage.size.height);
    self.clipImageView.cropImage.transform = CGAffineTransformScale(self.clipImageView.cropImage.transform, length/imageLength, length/imageLength);
    
    // 图片小于裁剪框
    [self.clipImageView handleScaleOverflowWithPoint:self.clipImageView.cropImage.center];
    CGPoint newCenter = [self.clipImageView handleBorderOverflow];
    self.clipImageView.cropImage.center = newCenter;
    [self.clipImageView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    self.view.userInteractionEnabled = YES;
    
    [self setGestureOperation];
}

#pragma mark - 懒加载
- (CropImageView *)clipImageView {
    if (!_clipImageView) {
        _clipImageView = [[CropImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_clipImageView];
    }
    return _clipImageView;
}

- (void)setClipImgRect:(CGRect)clipImgRect {
    self.clipImageView.cropGrid.clipRect = clipImgRect;
    [self.clipImageView initializeImageViewSize];
}

- (CGRect)clipImgRect {
    return self.clipImageView.cropGrid.clipRect;
}

- (void)setClipImage:(UIImage *)clipImage {
    self.clipImageView.cropImage.image = [self fixOrientation:clipImage];
    return [self.clipImageView initializeImageViewSize];
}

- (UIImage *)clipImage {
    return self.clipImageView.cropImage.image;
}

#pragma mark - 添加手势操作
- (void)setGestureOperation {
    //  拖动
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
    //  捏合
    UIPinchGestureRecognizer * pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinAction:)];
    pin.delegate = self;
    [self.view addGestureRecognizer:pin];
}

#pragma mark 进行拖动
- (void)panAction:(UIPanGestureRecognizer *)panOperation {
    UIView * imgView = self.clipImageView.cropImage;
    if (panOperation.state == UIGestureRecognizerStateBegan || panOperation.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panOperation translationInView:imgView.superview];
        [imgView setCenter:(CGPoint){(imgView.center.x + translation.x) , (imgView.center.y + translation.y)}];
        [panOperation setTranslation:CGPointZero inView:imgView.superview];
        self.centerPoint = CGPointMake(self.centerPoint.x + translation.x, self.centerPoint.y + translation.y);
    
    } else if (panOperation.state == UIGestureRecognizerStateEnded) {
        CGPoint newCenter = [self.clipImageView handleBorderOverflow];
        self.clipImageView.cropImage.center = newCenter;
    }
    
}

#pragma mark 放大缩小
- (void)pinAction:(UIPinchGestureRecognizer *)pinOperation {
    UIView * imgView = self.clipImageView.cropImage;
    self.touchPoint = [pinOperation locationInView:self.view];
    CGPoint pinPoint = [pinOperation locationInView:self.view];
    if (pinOperation.state == UIGestureRecognizerStateBegan || pinOperation.state == UIGestureRecognizerStateChanged) {
        CGFloat imgX = (pinPoint.x - imgView.center.x) * pinOperation.scale;
        CGFloat imgY = (pinPoint.y - imgView.center.y) * pinOperation.scale;
        imgView.transform = CGAffineTransformScale(imgView.transform, pinOperation.scale, pinOperation.scale);
        [imgView setCenter:(CGPoint){(pinPoint.x - imgX) , (pinPoint.y - imgY)}];
        pinOperation.scale = 1;
        
    } else if (pinOperation.state == UIGestureRecognizerStateEnded) {
        [self.clipImageView handleScaleOverflowWithPoint:pinPoint];
        CGPoint newCenter = [self.clipImageView handleBorderOverflow];
        self.clipImageView.cropImage.center = newCenter;
    }
    
}

#pragma mark - 处理裁剪的照片
- (UIImage *)clippingImage {
    CGRect squareFrame = self.clipImageView.cropGrid.clipRect;
    CGFloat scaleRatio = self.clipImageView.cropImage.frame.size.width / self.clipImage.size.width;
    CGFloat x = (squareFrame.origin.x - self.clipImageView.cropImage.frame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - self.clipImageView.cropImage.frame.origin.y) / scaleRatio;
    CGFloat width = squareFrame.size.width / scaleRatio;
    CGFloat height = squareFrame.size.height / scaleRatio;
    
    CGRect imageRect = CGRectMake(x, y, width, height);
    UIImage * image = [self.clipImage copy];
    image = [self cropImageWithImageName:image toRect:imageRect];
    
    return image;
}

- (UIImage *)cropImageWithImageName:(UIImage *)cropImage toRect:(CGRect)rectImage {
    CGImageRef imageRef = CGImageCreateWithImageInRect([cropImage CGImage], rectImage);
    UIImage * cropDoneImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropDoneImage;
}

- (UIImage *)fixOrientation:(UIImage *)srcImg {
    if (srcImg.imageOrientation == UIImageOrientationUp) return srcImg;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (srcImg.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, srcImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (srcImg.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, srcImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, srcImg.size.width, srcImg.size.height,
                                             CGImageGetBitsPerComponent(srcImg.CGImage), 0,
                                             CGImageGetColorSpace(srcImg.CGImage),
                                             CGImageGetBitmapInfo(srcImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (srcImg.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.height,srcImg.size.width), srcImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,srcImg.size.width,srcImg.size.height), srcImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end
