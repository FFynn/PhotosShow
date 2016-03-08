//
//  CameraView.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "CameraView.h"
#import "FiltersViewController.h"

@implementation CameraView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.cameraNavView];
        
        [self setCamere];
        
        [self addSubview:self.takePhotosBtn];
    }
    return self;
}

#pragma mark - 顶部导航
- (UIView *)cameraNavView {
    if (!_cameraNavView) {
        _cameraNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _cameraNavView.backgroundColor = [UIColor blackColor];

        [_cameraNavView addSubview:self.cameraTitlt];
        [_cameraNavView addSubview:self.flashBtn];
    }
    return _cameraNavView;
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

#pragma mark - 闪光灯按钮
- (UIButton *)flashBtn {
    if (!_flashBtn) {
        _flashBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 0, 50, 50)];
        [_flashBtn setImage:[UIImage imageNamed:@"ic_flash off"] forState:(UIControlStateNormal)];
        [_flashBtn setImage:[UIImage imageNamed:@"ic_flash on"] forState:(UIControlStateSelected)];
        [_flashBtn addTarget:self action:@selector(flashBtnClick) forControlEvents:(UIControlEventTouchUpInside)];

        
    }
    return _flashBtn;
}

- (void)flashBtnClick {
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if (_flashBtn.selected == NO) {
        device.flashMode = AVCaptureFlashModeOn;
        _flashBtn.selected = YES;
        NSLog(@"闪光灯已打开");
        
    } else if (_flashBtn.selected == YES) {
        device.flashMode = AVCaptureFlashModeOff;
        _flashBtn.selected = NO;
        NSLog(@"闪光灯已关闭");
    }
    
    [device unlockForConfiguration];
}


#pragma mark - 拍照按钮
- (UIButton *)takePhotosBtn {
    if (!_takePhotosBtn) {
        _takePhotosBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, SCREEN_HEIGHT * .75, 80, 80)]  ;
        [_takePhotosBtn setImage:[UIImage imageNamed:@"icon_capture"] forState:(UIControlStateNormal)];
        [_takePhotosBtn addTarget:self action:@selector(takePhotosBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        _takePhotosBtn.backgroundColor = [UIColor redColor];
        _takePhotosBtn.layer.cornerRadius = _takePhotosBtn.bounds.size.width / 2;
    }
    return _takePhotosBtn;
}

- (void)takePhotosBtnClick {
    //  控制输入和输出
    AVCaptureConnection * photoConnection = [self.photosOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //  设备的旋转方向
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation videoOrientation = [self photoDeviceOrientation:deviceOrientation];
    [photoConnection setVideoOrientation:videoOrientation];
    //  焦距
    [photoConnection setVideoScaleAndCropFactor:1];
    
    
    [self.photosOutput captureStillImageAsynchronouslyFromConnection:photoConnection
                                                   completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                       
                                                       NSData * photoData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                       
                                                       //   监测摄像头的权限
                                                       ALAuthorizationStatus photoStatus = [ALAssetsLibrary authorizationStatus];
                                                       if (photoStatus == ALAuthorizationStatusRestricted || photoStatus == ALAuthorizationStatusDenied) {
                                                           NSLog(@"请开启摄像头的权限");
                                                           
                                                       } else {
                                                           UIImage * image = [UIImage imageWithData:photoData];
                                                           UIImage * photo = [self cropImage:image withCropSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
                                                           //   跳转到“工具”视图
                                                           FiltersViewController * filtersVC = [[FiltersViewController alloc] init];
                                                           filtersVC.filtersImg = photo;
                                                           [self.Nav pushViewController:filtersVC animated:YES];
                                                       }
                                                       
                                                   }];
}

#pragma mark 拍摄后裁剪照片尺寸
- (UIImage *)cropImage:(UIImage *)image withCropSize:(CGSize)cropSize {
    UIImage *newImage = nil;
    
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = cropSize.width;
    CGFloat targetHeight = cropSize.height;
    
    CGFloat scaleFactor = 0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0, 0);
    
    if (CGSizeEqualToSize(imageSize, cropSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * .5f;
        } else {
            if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * .5f;
            }
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(cropSize, YES, 0);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [image drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark 获取设备的方向

- (AVCaptureVideoOrientation)photoDeviceOrientation:(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation videoOrientation = (AVCaptureVideoOrientation)deviceOrientation;
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        
    } else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
        videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    }
    return videoOrientation;
}

#pragma mark - 初始化相机
- (void)setCamere {
    
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    //设置闪光灯为关闭
    [device setFlashMode:AVCaptureFlashModeOff];
    [device unlockForConfiguration];
    
    
    //  初始化数据连接
    self.session = [[AVCaptureSession alloc] init];
    
    //  初始化设备
    AVCaptureDevice * cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //  初始化输入设备
    self.cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:cameraDevice error:nil];
    
    //  初始化图片输出
    self.photosOutput = [[AVCaptureStillImageOutput alloc] init];
    
    //  输出图像设置
    NSDictionary * outputSet = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.photosOutput setOutputSettings:outputSet];
    
    if ([self.session canAddInput:self.cameraInput]) {
        [self.session addInput:self.cameraInput];
    }
    if ([self.session canAddOutput:self.photosOutput]) {
        [self.session addOutput:self.photosOutput];
    }
    
    //  初始化预览图层
    self.previewPhoto = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewPhoto setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    //  预览图层的尺寸
    self.previewPhoto.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_WIDTH);
    self.layer.masksToBounds = YES;
    [self.layer addSublayer:self.previewPhoto];
}


@end

