//
//  YTVideoCell.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/11/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "YTVideoCell.h"

@implementation YTVideoCell

@synthesize previewImageView;
@synthesize titleLabel;
@synthesize dateLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
