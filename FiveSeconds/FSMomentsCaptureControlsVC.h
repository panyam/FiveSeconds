//
//  FSMomentsCaptureControlsVC.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVideoPlayerControls.h"
#import "FSRecording.h"
#import "FSCaptureSession.h"

@interface FSMomentsCaptureControlsVC : UIViewController<FSVideoPlayerControls>

@property (nonnull, strong) FSRecording *recording;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * _Nullable captureBarButtonItem;

@property (nonatomic, weak) FSVideoPlayer * _Nullable player;
@property (nonatomic, copy) FSVideoControlsCallback _Nullable callback;

-(IBAction)closeButtonClicked;
-(IBAction)captureButtonClicked:(_Nonnull id)sender;

-(NSUInteger)numCaptured;
-(FSCaptureSession *)currentSession;

@end
