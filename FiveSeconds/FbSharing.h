//
//  FbSharing.h
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/10/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#ifndef FbSharing_h
#define FbSharing_h
#import <UIKit/UIImage.h>
#import "ViewController.h"

@interface FbSharing : NSObject

- (void)shareImage:(UIImage *)image
            fromVC:(ViewController *)vc;

@end

#endif /* FbSharing_h */
