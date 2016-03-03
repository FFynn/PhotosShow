//
//  CropImageViewController.h
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "FBPictureViewController.h"
#import "ClipImageViewController.h"
#import "CropImageView.h"

@interface CropImageViewController : FBPictureViewController

@pro_strong ClipImageViewController     *   clipImageVC;
@pro_strong UIImage                     *   clipImage;

@end
