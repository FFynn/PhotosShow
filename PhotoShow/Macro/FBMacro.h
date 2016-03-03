//
//  FBMacro.h
//  PhotoShow
//
//  Created by FLYang on 16/3/3.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#ifndef FBMacro_h
#define FBMacro_h


#undef 宽高尺寸
//  屏幕宽
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
//  屏幕高
#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width


#undef Property
//  strong
#define pro_strong  property (nonatomic, strong)
//  weak
#define pro_weak    property (nonatomic, weak)
//  assign
#define pro_assign  property (nonatomic, assign)
//  copy
#define pro_copy    property (nonatomic, copy)


#endif /* FBMacro_h */
