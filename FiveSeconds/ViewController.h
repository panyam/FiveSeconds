//
//  ViewController.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/8/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import "YTPlayerView.h"

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, YTPlayerViewDelegate>

@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet AVPlayerViewController *playerViewController;
@property (nonatomic, strong) IBOutlet YTPlayerView *ytPlayerView;
@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIView *touchRecordingView;

-(IBAction)capturePhotos:(id)sender;
-(IBAction)loadVideo:(id)sender;
-(IBAction)startRecordTimes:(id)sender;
-(IBAction)stopRecordTimes:(id)sender;
-(IBAction)recordCurrentTime:(id)sender;

@end

