//
//  YTVideoCell.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/11/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTVideoCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *previewImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end
