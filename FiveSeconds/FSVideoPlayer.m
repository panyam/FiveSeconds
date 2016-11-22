//
//  FSVideoPlayer.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/19/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVideoPlayer.h"
#import "FSUtils.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "FSVideoPlayerControls.h"
#import "FSRecording.h"

@interface FSVideoPlayer()

@property (nonatomic, strong) UIWindow *playerWindow;
@property (nonatomic, strong) UIWindow *controlsWindow;
@property (nonnull, strong) NSMutableArray *recordedOffsets;

@end

@implementation FSVideoPlayer

@synthesize currentVideo;
@synthesize playerWindow;
@synthesize controlsWindow;
@synthesize recordedOffsets;

+(FSVideoPlayer *)sharedInstance
{
    static FSVideoPlayer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FSVideoPlayer alloc] init];
    });
    return instance;
}

-(id)init {
    return [self initWithVideo:nil];
}

-(id)initWithVideo:(FSVideo *)video {
    self = [super init];
    if (self) {
        [self initializeWindows];
        self.currentVideo = video;
    }
    return self;
}

-(void)initializeWindows {
    CGRect mainBounds = [[UIScreen mainScreen] bounds];
    self.playerWindow = [[UIWindow alloc] initWithFrame:mainBounds];
    self.controlsWindow = [[UIWindow alloc] initWithFrame:mainBounds];
    FSOffsetsRecorderControlsVC *controlsVC = [[FSOffsetsRecorderControlsVC alloc] initWithNibName:nil bundle:nil];
    self.controlsWindow.rootViewController = controlsVC;
    controlsVC.callback = ^(id<FSVideoPlayerControls> controls, NSString *action, id actionData) {
        return [self handleAction:action forControls:controls withData:actionData];
    };
}

-(BOOL)isHidden {
    return self.playerWindow.isHidden;
}

-(void)show {
    if (self.isHidden) {
        [self.playerWindow setHidden:NO];
        [self.playerWindow makeKeyAndVisible];
        [self.controlsWindow setHidden:NO];
        [self.controlsWindow makeKeyAndVisible];
    }
}

-(void)hide {
    if (!self.isHidden) {
        [self.currentVideo stop];
        [self.playerWindow setHidden:YES];
        [self.playerWindow resignKeyWindow];
        [self.controlsWindow setHidden:YES];
        [self.controlsWindow resignKeyWindow];
    }
}

-(void)setCurrentVideo:(FSVideo *)video {
    [self.currentVideo releasePlayer:self];
    currentVideo = video;
    self.playerWindow.rootViewController = nil;
    if (video) {
        [self.currentVideo preparePlayer:self];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"Here...., Self: %@", self);
        });
    }
}

@end
