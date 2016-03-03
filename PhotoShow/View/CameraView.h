//
//  CameraView.h
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBMacro.h"

@interface CameraView : UIView

@pro_strong UIViewController    *   VC;
@pro_strong UIView              *   cameraNavView;      //  顶部导航
@pro_strong UIButton            *   cameraCancelBtn;    //  取消按钮
@pro_strong UILabel             *   cameraTitlt;        //  页面标题

@end
