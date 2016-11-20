//
//  FSVideoControlsVC.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/20/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSVideoControlsVC.h"

@interface FSVideoControlsVC ()

@end

@implementation FSVideoControlsVC

@synthesize restartBarButtonItem;
@synthesize playBarButtonItem;
@synthesize recordBarButtonItem;
@synthesize onClose;
@synthesize onRestart;
@synthesize onStartPlaying;
@synthesize onPausePlaying;
@synthesize onStartRecording;
@synthesize onStopRecording;

@synthesize captureOffsetsOnTouch;

-(void)viewDidLoad {
    [super viewDidLoad];    
}

-(IBAction)closeButtonClicked {
    if (self.onClose) {
        self.onClose(self, nil);
    }
}

-(IBAction)restartButtonClicked:(id)sender {
    if (self.onRestart) {
        ((UIBarButtonItem *)sender).enabled = NO;
        self.onRestart(sender, nil);
    }
}

-(IBAction)playButtonClicked:(id)sender {
    UIBarButtonItem *item = sender;
    if ([item.title isEqualToString:@"Play"] && self.onStartPlaying) {
        item.enabled = NO;
        self.onStartPlaying(item, nil);
    }
    else if ([item.title isEqualToString:@"Pause"] && self.onPausePlaying) {
        item.enabled = NO;
        self.onPausePlaying(item, nil);
    }
}

-(IBAction)recordButtonClicked:(id)sender {
    UIBarButtonItem *item = sender;
    if ([item.title isEqualToString:@"Record"] /* && self.onStartRecording*/) {
        item.enabled = NO;
        self.captureOffsetsOnTouch = YES;
        item.title = @"Stop";
        item.enabled = YES;
    }
    else if ([item.title isEqualToString:@"Stop"] /* && self.onStopRecording */) {
        item.enabled = NO;
        self.captureOffsetsOnTouch = NO;
        item.title = @"Record";
        item.enabled = YES;
    }
}

-(IBAction)touchRecorded:(id)sender {
    if (self.captureOffsetsOnTouch && self.onTouchRecorded) {
        self.onTouchRecorded(nil, nil);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
