//
//  FSVideoPlayer.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/19/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FSVideo.h"

@protocol FSVideoPlayerControls;

@interface FSVideoPlayer : NSObject

@property (nonatomic) FSVideo *currentVideo;
@property (nonatomic, strong) id<FSVideoPlayerControls> controls;

+(FSVideoPlayer *)sharedInstance;

-(UIWindow *)playerWindow;
-(void)show;
-(void)hide;

@end
