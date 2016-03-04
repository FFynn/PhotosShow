//
//  FiltersView.m
//  fineix
//
//  Created by FLYang on 16/3/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiltersView.h"
#import "FBFiltersCollectionViewCell.h"
#import "FBFilters.h"

@implementation FiltersView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.filters = [NSArray arrayWithObjects:
                        @"CIColorCrossPolynomial",
                        @"CIColorCube",
                        @"CIColorCubeWithColorSpace",
                        @"CIColorInvert",
                        @"CIColorMonochrome",
                        @"CIColorPosterize",
                        @"CIFalseColor",
                        @"CIMaskToAlpha",
                        @"CIMaximumComponent",
                        @"CIMinimumComponent",
                        @"CIPhotoEffectChrome",
                        @"CIPhotoEffectFade",
                        @"CIPhotoEffectInstant",
                        @"CIPhotoEffectMono",
                        @"CIPhotoEffectNoir",
                        @"CIPhotoEffectProcess",
                        @"CIPhotoEffectTonal",
                        @"CIPhotoEffectTransfer",
                        @"CISepiaTone",
                        @"CIVignette", nil];
        
        
        [self addSubview:self.filtersCollectionView];
    }
    return self;
}

#pragma mark - 滤镜菜单
- (UICollectionView *)filtersCollectionView {
    if (!_filtersCollectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(85, 120);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 7.5, 0, 7.5);
        flowLayout.minimumInteritemSpacing = 2.0;
        flowLayout.minimumLineSpacing = 2.0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //  设置横向滑动
        
        _filtersCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120) collectionViewLayout:flowLayout];
        _filtersCollectionView.backgroundColor = [UIColor blackColor];
        _filtersCollectionView.showsHorizontalScrollIndicator = NO;
        _filtersCollectionView.showsVerticalScrollIndicator = NO;
        _filtersCollectionView.delegate = self;
        _filtersCollectionView.dataSource = self;

        [_filtersCollectionView registerClass:[FBFiltersCollectionViewCell class] forCellWithReuseIdentifier:@"FBFiltersCollectionViewCell"];
    }
    return _filtersCollectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * filtersCellID = @"FBFiltersCollectionViewCell";
    FBFiltersCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:filtersCellID forIndexPath:indexPath];
    cell.filtersTitle.text = self.filters[indexPath.row];
    
    UIImage * img = [[FBFilters alloc] initWithImage:[UIImage imageNamed:@"asd"] filterName:self.filters[indexPath.row]].filterImg;
    cell.filtersImageView.image = img;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fitlerName" object:self.filters[indexPath.row]];
}

@end
