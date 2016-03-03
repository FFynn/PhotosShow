//
//  FBLoadPhoto.h
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBPhoto.h"

@interface FBLoadPhoto : NSObject

//  加载相片
+ (void)loadAllPhotos:(void (^)(NSArray * photos, NSError * error))completion;

//  加载相册
+ (void)loadAllPhotoAlbum:(void (^)(NSArray * photoAlbum, NSError * error))done;

@end
