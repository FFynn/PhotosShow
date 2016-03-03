//
//  CreateViewController.h
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "FBPictureViewController.h"
#import "FBFootView.h"
#import "CameraView.h"

@interface CreateViewController : FBPictureViewController

@pro_strong UIView              *   createView;         //  创建场景页面
@pro_strong FBFootView          *   footView;           //  底部功能选择视图
@pro_strong UICollectionView    *   pictureView;        //  照片列表
@pro_strong UIImageView         *   photoImgView;       //  选中显示的照片
@pro_strong CameraView          *   cameraView;         //  相机页面
@pro_strong UIButton            *   recoveryFrameBtn;   //  恢复视图位置

@pro_strong NSArray             *   photosArr;          //  全部的相片
@pro_strong NSMutableArray      *   sortPhotosArr;      //  排序的相片
@pro_strong NSArray             *   photoAlbumArr;      //  全部的相薄

@end
