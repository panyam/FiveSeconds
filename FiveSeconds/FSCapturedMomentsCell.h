//
//  FSCapturedMomentsCell.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSCapturedMomentsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *previewImageView;
@property (nonatomic, strong) IBOutlet UICollectionView *thumbnailsView;
@property (nonatomic, strong) IBOutlet UILabel *dateTakenLabel;

@end
