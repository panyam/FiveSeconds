//
//  FbSharing.h
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/10/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIImage.h>
#import "ViewController.h"

@interface FbSharing : NSObject

- (void)shareImage:(UIImage *)image
            fromVC:(ViewController *)vc;

@end

