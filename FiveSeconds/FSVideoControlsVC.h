//
//  FSVideoControlsVC.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/20/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSUtils.h"

@interface FSVideoControlsVC : UIViewController

@property (nonatomic, strong) IBOutlet UIBarButtonItem * restartBarButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * playBarButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * recordBarButtonItem;

@property (nonnull, readonly) NSArray *recordedOffsets;
@property (nonatomic) BOOL captureOffsetsOnTouch;

@property (nonatomic, copy) _Nullable FSCallback onClose;
@property (nonatomic, copy) _Nullable FSCallback onStartPlaying;
@property (nonatomic, copy) _Nullable FSCallback onPausePlaying;
@property (nonatomic, copy) _Nullable FSCallback onStartRecording;
@property (nonatomic, copy) _Nullable FSCallback onStopRecording;
@property (nonatomic, copy) _Nullable FSCallback onRestart;
@property (nonatomic, copy) _Nullable FSCallback onTouchRecorded;

-(IBAction)closeButtonClicked;
-(IBAction)restartButtonClicked:(_Nonnull id)sender;
-(IBAction)recordButtonClicked:(_Nonnull id)sender;
-(IBAction)playButtonClicked:(_Nonnull id)sender;
-(IBAction)touchRecorded:(_Nonnull id)sender;

@end
