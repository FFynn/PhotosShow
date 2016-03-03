//
//  FBPictureViewController.h
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBMacro.h"

@interface FBPictureViewController : UIViewController

@pro_strong UIView              *   navView;        //  顶部滚动栏
@pro_strong UILabel             *   navTitle;       //  顶部标题

@pro_strong UIButton            *   cancelBtn;      //  取消按钮
@pro_strong UIButton            *   backBtn;        //  返回按钮
@pro_strong UIButton            *   doneBtn;        //  完成发布按钮

@pro_strong UIButton            *   nextBtn;        //  继续按钮
@pro_strong UIButton            *   cropBack;       //  "裁剪"返回

//  导航视图
- (void)addNavViewTitle:(NSString *)title;

//  取消按钮
- (void)addCancelButton;

//  继续按钮
- (void)addNextButton;

//  返回按钮
- (void)addBackButton;

//  发布按钮
- (void)addDoneButton;


@end
