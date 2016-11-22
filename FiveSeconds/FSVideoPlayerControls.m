//
//  FSOffsetsRecorderControlsVC.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/20/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSVideoPlayerControls.h"
#import "FSVideoPlayer.h"

@interface FSOffsetsRecorderControlsVC ()

@end

@implementation FSOffsetsRecorderControlsVC

@synthesize restartBarButtonItem;
@synthesize playBarButtonItem;
@synthesize recordBarButtonItem;
@synthesize callback;
@synthesize recordedOffsets;

@synthesize captureOffsetsOnTouch;
@synthesize player;

-(void)viewDidLoad {
    [super viewDidLoad];    
}

-(IBAction)closeButtonClicked {
    if (self.callback) {
        self.callback(self, @"close", nil);
    }
}

-(IBAction)restartButtonClicked:(id)sender {
    if (self.callback) {
        ((UIBarButtonItem *)sender).enabled = NO;
        self.callback(self, @"restart", sender);
    }
}

-(IBAction)playButtonClicked:(id)sender {
    UIBarButtonItem *item = sender;
    if (self.callback) {
        if ([item.title isEqualToString:@"Play"]) {
            item.enabled = NO;
            self.callback(self, @"play", item);
        }
        else if ([item.title isEqualToString:@"Pause"]) {
            item.enabled = NO;
            self.callback(self, @"pause", item);
        }
    }
}

-(IBAction)recordButtonClicked:(id)sender {
    UIBarButtonItem *item = sender;
    if ([item.title isEqualToString:@"Record"]) {
        item.enabled = NO;
        self.captureOffsetsOnTouch = YES;
        item.title = @"Stop";
        item.enabled = YES;
    }
    else if ([item.title isEqualToString:@"Stop"]) {
        item.enabled = NO;
        self.captureOffsetsOnTouch = NO;
        item.title = @"Record";
        item.enabled = YES;
    }
}

-(IBAction)touchRecorded:(id)sender {
    if (self.captureOffsetsOnTouch && self.callback) {
        NSNumber *offset = [NSNumber numberWithDouble:self.player.currentVideo.offset];
        if (!self.recordedOffsets)
            self.recordedOffsets = [NSMutableArray array];
        [self.recordedOffsets addObject:offset];
        self.callback(self, @"recorded", offset);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
