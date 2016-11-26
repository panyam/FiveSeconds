//
//  FSCapturedMomentCell.m
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/25/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSCapturedMomentCell.h"

@implementation FSCapturedMomentCell

@synthesize imageView;

// Lazy loading of the imageView
- (UIImageView *) imageView
{
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:imageView];
    }
    return imageView;
}

// Here we remove all the custom stuff that we added to our subclassed cell
-(void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.imageView removeFromSuperview];
    self.imageView = nil;
}

@end
