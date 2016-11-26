//
//  FSCaptureSessionCell.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFIndexedCollectionView : UICollectionView
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *sessionId;
@end

static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface FSCaptureSessionCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *previewImageView;
@property (nonatomic, strong) IBOutlet UICollectionView *thumbnailsView;
@property (nonatomic, strong) IBOutlet UILabel *dateTakenLabel;
@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, strong) IBOutlet AFIndexedCollectionView *collectionView;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end
