//
//  FSCaptureSessionCell.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSCaptureSessionCell.h"

@implementation AFIndexedCollectionView

@end

@implementation FSCaptureSessionCell

@synthesize previewImageView;
@synthesize thumbnailsView;
@synthesize dateTakenLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//    layout.itemSize = CGSizeMake(44, 44);
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    self.collectionView = [[AFIndexedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
//    self.collectionView.backgroundColor = [UIColor whiteColor];
//    self.collectionView.showsHorizontalScrollIndicator = NO;
//    [self.contentView addSubview:self.collectionView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.collectionView.frame = self.contentView.bounds;
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
    
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
