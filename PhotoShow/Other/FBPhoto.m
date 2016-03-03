//
//  FBPhoto.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "FBPhoto.h"

@implementation FBPhoto

//  获取缩略图
- (UIImage *)thumbnailImage {
    UIImage * thuImg = [UIImage imageWithCGImage:self.asset.thumbnail];
    return thuImg;
}

//  获取原始图
- (UIImage *)originalImage {
    UIImage * oriImg = [UIImage imageWithCGImage:self.asset.defaultRepresentation.fullResolutionImage
                                           scale:self.asset.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)self.asset.defaultRepresentation.orientation];
    return oriImg;
}

@end
