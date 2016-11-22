//
//  CapturedMomentsCell.m
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CapturedMomentsCell.h"

@implementation CapturedMomentsCell

@synthesize previewImageView;
@synthesize titleLabel;
@synthesize photos;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
