//
//  FSOffsetsRecorderControlsVC.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/20/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSUtils.h"

@class FSVideoPlayer;
@protocol FSVideoPlayerControls;

typedef BOOL (^FSVideoControlsCallback)(NSObject<FSVideoPlayerControls> * _Nonnull controls,
                                        NSString * _Nonnull action, NSObject * _Nullable actionData);

@protocol FSVideoPlayerControls

// The current player the controls are assigned to.
@property (nonatomic, weak) FSVideoPlayer * _Nullable player;
@property (nonatomic, copy) FSVideoControlsCallback _Nullable callback;

@end


@interface FSOffsetsRecorderControlsVC : UIViewController<FSVideoPlayerControls>

@property (nonatomic, weak) FSVideoPlayer * _Nullable player;
@property (nonatomic, copy) FSVideoControlsCallback _Nullable callback;

@property (nonatomic, strong) IBOutlet UIBarButtonItem * _Nullable restartBarButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * _Nullable playBarButtonItem;
@property (nonatomic, strong) IBOutlet UIBarButtonItem * _Nullable recordBarButtonItem;

@property (nonatomic, strong) NSMutableArray * _Nullable recordedOffsets;
@property (nonatomic) BOOL captureOffsetsOnTouch;

-(IBAction)closeButtonClicked;
-(IBAction)restartButtonClicked:(_Nonnull id)sender;
-(IBAction)recordButtonClicked:(_Nonnull id)sender;
-(IBAction)playButtonClicked:(_Nonnull id)sender;
-(IBAction)touchRecorded:(_Nonnull id)sender;

@end
