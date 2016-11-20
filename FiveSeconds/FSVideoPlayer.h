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

@interface FSVideoPlayer : NSObject

@property (nonatomic) FSVideo *currentVideo;

+(FSVideoPlayer *)sharedInstance;

-(UIWindow *)playerWindow;
-(UIWindow *)controlsWindow;
-(void)show;
-(void)hide;

@end
