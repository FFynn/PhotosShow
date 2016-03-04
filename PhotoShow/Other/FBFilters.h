//
//  FBFilters.h
//  PhotoShow
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FBMacro.h"

@interface FBFilters : NSObject

@property (nonatomic, strong, readonly) UIImage         *   filterImg;

- (instancetype)initWithImage:(UIImage *)image filterName:(NSString *)name;

@end

