//
//  CreateViewController.m
//  PhotpShow
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 Fynn. All rights reserved.
//

#import "CreateViewController.h"
#import "FBLoadPhoto.h"
#import "FBPictureCollectionViewCell.h"

#import "CropImageViewController.h"

@interface CreateViewController () <FBFootViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavViewUI];
    
    [self setCreateControllerUI];
    
    [self loadAllPhotos];
    
    [self pictureViewZoom];
}

#pragma mark - 设置顶部Nav
- (void)setNavViewUI {
    [self addNavViewTitle:@"照片胶卷"];
    [self addCancelButton];
    [self addNextButton];
    
    [self.nextBtn addTarget:self action:@selector(nextButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark - 点击“继续”
- (void)nextButtonClick:(UIImage *)image {
    CropImageViewController * cropVC = [[CropImageViewController alloc] init];
    cropVC.clipImageVC.clipImage = self.photoImgView.image;
    cropVC.view.frame = self.view.frame;

    [self.navigationController pushViewController:cropVC animated:YES];
}

#pragma mark - 创建页面UI
- (void)setCreateControllerUI {
    
    //  底部选项栏
    [self.view addSubview:self.footView];
    
    //  选择照片视图
    [self.view addSubview:self.createView];
    
    //  恢复相册视图位置的按钮
    [self.view addSubview:self.recoveryFrameBtn];
    self.recoveryFrameBtn.hidden = YES;

}

- (UIView *)createView {
    if (!_createView) {
        _createView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
        _createView.backgroundColor = [UIColor blackColor];
        
        //  相册列表
        [_createView addSubview:self.pictureView];
        
        //  显示的照片
        [_createView addSubview:self.photoImgView];
        
    }
    return _createView;
}

#pragma mark 底部选项工具栏
- (FBFootView *)footView {
    if (!_footView) {
        NSArray * arr = [NSArray arrayWithObjects:@"相册", @"拍照", nil];
        _footView = [[FBFootView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
        _footView.backgroundColor = [UIColor blackColor];
        _footView.titleArr = arr;
        [_footView addFootViewButton];
        [_footView showLineWithButton];
        _footView.delegate = self;
    }
    return _footView;
}

#pragma mark 底部选项的点击事件
- (void)buttonDidSeletedWithIndex:(NSInteger)index {
    if (index == 1) {
        self.createView.hidden = YES;
        //  自定义相机的视图
        [self.view addSubview:self.cameraView];
        [self.recoveryFrameBtn removeFromSuperview];
        
    } else if (index == 0) {
        //  清除相机的视图
        [self.cameraView removeFromSuperview];
        self.createView.hidden = NO;
        [self.view addSubview:self.recoveryFrameBtn];
    }
}

#pragma mak - 打开相机的页面
- (CameraView *)cameraView {
    if (!_cameraView) {
        _cameraView = [[CameraView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
        _cameraView.VC = self;
    }
    return _cameraView;
}

#pragma mark - 显示的照片
- (UIImageView *)photoImgView {
    if (!_photoImgView) {
        _photoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 302)];
        _photoImgView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImgView.clipsToBounds  = YES;
        [_photoImgView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    }
    return _photoImgView;
}

#pragma mark - 上滑拉伸显示全部相片列表
- (void)pictureViewZoom{
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pictureViewZoom:)];
    pan.delegate = self;
    [self.pictureView addGestureRecognizer:pan];
}

#pragma mark 相片列表上滑展示全部相片
- (void)pictureViewZoom:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateChanged) {
        //  上滑的距离
        CGFloat panfloat = [pan translationInView:self.pictureView].y;
        //  相册列表的frame
        CGRect pictureViewRect = self.pictureView.frame;
        //  显示画布的frame
        CGRect photoViewRect = self.photoImgView.frame;
        
        if (panfloat < -200) {
            pictureViewRect = CGRectMake(0, 0, SCREEN_WIDTH, self.createView.bounds.size.height);
            [UIView animateWithDuration:.5 animations:^{
                self.pictureView.frame = pictureViewRect;
                [self.createView bringSubviewToFront:self.pictureView];
            }];
            
            photoViewRect = CGRectMake(0, -(SCREEN_HEIGHT - 305), SCREEN_WIDTH, SCREEN_HEIGHT - 305);
            [UIView animateWithDuration:.5 animations:^{
                self.photoImgView.frame = photoViewRect;
            } completion:^(BOOL finished) {
                self.recoveryFrameBtn.hidden = NO;
            }];
        
        }
        
        //  照片列表的偏移量
        CGFloat pictureViewFloat = self.pictureView.contentOffset.y;
        
        if (pictureViewFloat < -50) {
            photoViewRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 305);
            [UIView animateWithDuration:.5 animations:^{
                self.photoImgView.frame = photoViewRect;
                self.recoveryFrameBtn.hidden = YES;
            }];
            
            pictureViewRect = CGRectMake(0, self.photoImgView.bounds.size.height + 2, SCREEN_WIDTH, 200);
            [UIView animateWithDuration:.5 animations:^{
                self.pictureView.frame = pictureViewRect;
            }];
        }
    }
}

#pragma mark 点击恢复初始位置的按钮
- (UIButton *)recoveryFrameBtn {
    if (!_recoveryFrameBtn) {
        _recoveryFrameBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _recoveryFrameBtn.backgroundColor = [UIColor blackColor];
        _recoveryFrameBtn.alpha = 0.5;
        
        UILabel * lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, SCREEN_WIDTH, 3)];
        lineLab.backgroundColor = [UIColor blackColor];
        lineLab.layer.shadowColor = [UIColor blackColor].CGColor;
        lineLab.layer.shadowOffset = CGSizeMake(0, 2);
        lineLab.layer.shadowOpacity = 1.0f;
        [_recoveryFrameBtn addSubview:lineLab];
        
        [_recoveryFrameBtn addTarget:self action:@selector(cancelFrameBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _recoveryFrameBtn;
}

- (void)cancelFrameBtnClick {
    //  显示照片列表的frame
    CGRect pictureViewRect = self.pictureView.frame;
    pictureViewRect = CGRectMake(0, self.photoImgView.bounds.size.height + 2, SCREEN_WIDTH, 200);
    [UIView animateWithDuration:.5 animations:^{
        self.pictureView.frame = pictureViewRect;
    }];
    
    //  显示画布的frame
    CGRect photoViewRect = self.photoImgView.frame;
    photoViewRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 305);
    [UIView animateWithDuration:.5 animations:^{
        self.photoImgView.frame = photoViewRect;
        self.recoveryFrameBtn.hidden = YES;
    }];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UICollectionView class]]) {
        return YES;
    }
    return NO;
}

#pragma mark - 相册的列表视图
- (UICollectionView *)pictureView {
    if (!_pictureView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 6) / 4, (SCREEN_WIDTH - 6) / 4);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.minimumInteritemSpacing = 2.0;
        flowLayout.minimumLineSpacing = 2.0;
        
        _pictureView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 300, SCREEN_WIDTH, 200) collectionViewLayout:flowLayout];
        _pictureView.delegate = self;
        _pictureView.dataSource = self;
        _pictureView.backgroundColor = [UIColor blackColor];
        _pictureView.showsHorizontalScrollIndicator = NO;
        _pictureView.showsVerticalScrollIndicator = NO;
        [_pictureView registerClass:[FBPictureCollectionViewCell class] forCellWithReuseIdentifier:@"FBPictureCollectionViewCell"];
    }
    return _pictureView;
}

#pragma mark  UICollectionViewDataSource(相册列表)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sortPhotosArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * collectionViewCellIdentifier = @"FBPictureCollectionViewCell";
    
    FBPictureCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier forIndexPath:indexPath];
    FBPhoto * photo = [self.sortPhotosArr objectAtIndex:indexPath.row];
    cell.imageView.image = photo.thumbnailImage;
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FBPhoto * photo = [self.sortPhotosArr objectAtIndex:indexPath.row];
    self.photoImgView.image = photo.originalImage;
    
    if (self.pictureView.frame.size.height > 200) {
        //  显示画布的frame
        CGRect photoViewRect = self.photoImgView.frame;
        photoViewRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 305);
        [UIView animateWithDuration:.5 animations:^{
            self.photoImgView.frame = photoViewRect;
            self.recoveryFrameBtn.hidden = YES;
        }];
        
        //  显示照片列表的frame
        CGRect pictureViewRect = self.pictureView.frame;
        pictureViewRect = CGRectMake(0, self.photoImgView.bounds.size.height + 2, SCREEN_WIDTH, 200);
        [UIView animateWithDuration:.5 animations:^{
            self.pictureView.frame = pictureViewRect;
        }];

    }

}

#pragma mark - 加载所有的相片
- (void)loadAllPhotos {
    self.sortPhotosArr = [NSMutableArray array];
    
    [FBLoadPhoto loadAllPhotos:^(NSArray *photos, NSError *error) {
        if (!error) {
            self.photosArr = [NSArray arrayWithArray:photos];
            //  相片由近到远排序
            NSEnumerator * enumerator = [self.photosArr reverseObjectEnumerator];
            id pictureObject;
            while (pictureObject = [enumerator nextObject]) {
                [self.sortPhotosArr addObject:pictureObject];
            }

            if (self.photosArr.count) {
                //  默认加载第一张照片
                FBPhoto * firstPhoto = [self.sortPhotosArr objectAtIndex:0];
                self.photoImgView.image = firstPhoto.originalImage;
            }
            [self.pictureView reloadData];
            //  默认选中照片列表第一个
            [self.pictureView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                           animated:YES
                                     scrollPosition:(UICollectionViewScrollPositionNone)];

        } else {
            NSLog(@"＝＝＝＝＝＝＝ 加载图片错误%@ ＝＝＝＝＝＝＝", error);
        }
    }];
}

#pragma mark - 获取所有的相薄
- (void)loadAllPhotoAlbum {
    [FBLoadPhoto loadAllPhotoAlbum:^(NSArray * photoAlbum, NSError *error) {
        if (!error) {
            self.photoAlbumArr = [NSArray arrayWithArray:photoAlbum];
        
        } else {
            NSLog(@"＝＝＝＝＝＝＝ 加载相册错误%@ ＝＝＝＝＝＝＝", error);
        }
    }];
}


@end
