//
//  FBFootView.h
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBMacro.h"

@protocol FBFootViewDelegate <NSObject>

@optional

- (void)buttonDidSeletedWithIndex:(NSInteger)index;

@end

@interface FBFootView : UIView

@pro_strong UIScrollView    *   buttonView;     //  按钮视图
@pro_strong NSArray         *   titleArr;       //  底部按钮标题
@pro_strong UILabel         *   line;           //  导航条
@pro_strong UIButton        *   seletedBtn;     //  保存上次点击的button

@pro_weak id <FBFootViewDelegate> delegate;

- (void)addFootViewButton;
- (void)showLineWithButton;

@end
