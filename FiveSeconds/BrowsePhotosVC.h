//
//  BrowsePhotosVC.h
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/14/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface BrowsePhotosVC : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@property (nonatomic, strong) NSMutableArray<UIImage*> *items;

@end
