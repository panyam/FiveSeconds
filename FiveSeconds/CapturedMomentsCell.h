//
//  CapturedMomentsCell.h
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CapturedMomentsCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *previewImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UICollectionView *photos;
@end
