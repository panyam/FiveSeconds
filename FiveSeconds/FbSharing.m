//
//  FbSharing.m
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/10/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FbSharing.h"
#import <UIKit/UIImage.h>
#import <FBSDKShareKit/FBSDKSharePhoto.h>
#import <FBSDKShareKit/FBSDKSharePhotoContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>

@implementation FbSharing

- (void)shareImage:(UIImage *)image
            fromVC:(UIViewController *) vc {
    // Override point for customization after application launch.
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    [FBSDKShareDialog showFromViewController:vc
                                 withContent:content
                                    delegate:nil];
}

@end
