//
//  BrowsePhotosController.h
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/13/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"


@interface BrowsePhotosController : UIViewController <iCarouselDataSource, iCarouselDelegate>

- (instancetype)initWithImages:(NSArray<UIImage *>*)images;

@end
