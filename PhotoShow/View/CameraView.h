//
//  CameraView.h
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "FBMacro.h"

@interface CameraView : UIView

@pro_strong UINavigationController      *   Nav;
@pro_strong UIViewController            *   VC;
@pro_strong UIView                      *   cameraNavView;      //  顶部导航
@pro_strong UILabel                     *   cameraTitlt;        //  页面标题

@pro_strong UIButton                    *   takePhotosBtn;      //  拍照按钮
@pro_strong UIButton                    *   flashBtn;           //  闪光灯按钮
@pro_strong AVCaptureSession            *   session;            //  输入&输出之间的数据传递
@pro_strong AVCaptureDeviceInput        *   cameraInput;        //  图像输入设备
@pro_strong AVCaptureStillImageOutput   *   photosOutput;       //  照片输出
@pro_strong AVCaptureVideoPreviewLayer  *   previewPhoto;       //  预览照片图层

@end
