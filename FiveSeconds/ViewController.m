//
//  ViewController.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/8/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <SPiOSUtils/SPMobileUtils.h>
#import "ViewController.h"
#import "FbSharing.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "FSUtils.h"
#import "BrowsePhotosController.h"
#import "BrowsePhotosVC.h"

typedef enum {
    RequestedVideoSource_Album,
    RequestedVideoSource_YouTube,
} RequestedVideoSource;

@interface ViewController ()

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic) RequestedVideoSource requestedVideoSource;
@property (nonatomic) NSMutableArray<UIImage *> *capturedImages;
@property (nonatomic, strong) NSDate *videoStartedTime;
@property (nonatomic, strong) NSMutableArray *recordedTimes;

@end

@implementation ViewController

@synthesize videoStartedTime;
@synthesize touchRecordingView;
@synthesize toolbar;
@synthesize ytPlayerView;
@synthesize stillImageOutput;
@synthesize videoConnection;
@synthesize captureSession;
@synthesize containerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeCamera];
 
    self.ytPlayerView.delegate = self;
    self.playerViewController = [[AVPlayerViewController alloc] init];
    [self addChildViewController:self.playerViewController];
    [self.containerView addSubview:self.playerViewController.view];
    [self.containerView addSubview:self.ytPlayerView];
    self.capturedImages = [[NSMutableArray alloc] init];
    self.touchRecordingView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoSelected:)
                                                 name:VideoSelectedNotification object:nil];
}


-(void)viewDidAppear:(BOOL)animated {
//    CGRect ourFrame = self.view.frame;
//    CGRect toolbarFrame = self.toolbar.frame;
    CGSize containerSize = self.containerView.frame.size;
    self.playerViewController.view.frame =
    self.ytPlayerView.frame = CGRectMake(0,0, containerSize.width, containerSize.height);
    [super viewDidAppear:animated];
}

-(void)initializeCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.captureSession = [[AVCaptureSession alloc] init];
        self.captureSession.sessionPreset = AVCaptureSessionPresetMedium;
        
        AVCaptureDevice *frontCamera = nil;
        NSArray *devices = [AVCaptureDevice devices];
        for (AVCaptureDevice *device in devices) {
            NSLog(@"Device name: %@", [device localizedName]);
            if ([device hasMediaType:AVMediaTypeVideo]) {
                if ([device position] == AVCaptureDevicePositionFront) {
                    frontCamera = device;
                    break;
                }
            }
        }
        if (frontCamera) {
            if ([frontCamera isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
                CGPoint autofocusPoint = CGPointMake(0.5f, 0.5f);
                NSError *error = nil;
                if ([frontCamera lockForConfiguration:&error]) {
                    if (error) {
                    }
                    [frontCamera setFocusPointOfInterest:autofocusPoint];
                    [frontCamera setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                    if (frontCamera.hasFlash) {
                        frontCamera.flashMode = AVCaptureFlashModeOff;
                    }
                    [frontCamera unlockForConfiguration];
                }
            }
        }
        
        // Attach device to session
        NSError *error;
        AVCaptureDeviceInput *captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        if (captureDeviceInput) {
            // Handle the error appropriately.
            if ([self.captureSession canAddInput:captureDeviceInput]) {
                [self.captureSession addInput:captureDeviceInput];
            }
        }
        
        self.videoConnection = nil;
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
        [self.stillImageOutput setOutputSettings:outputSettings];
        if ([self.captureSession canAddOutput:self.stillImageOutput]) {
            [self.captureSession addOutput:self.stillImageOutput];
            
            // Add inputs and outputs.
            [self.captureSession startRunning];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)startRecordTimes:(id)sender {
    self.recordedTimes = nil;
    self.videoStartedTime = [NSDate date];
    if (self.ytPlayerView.hidden) {
        // playing from album
        [SPMU_ACTIVITY_INDICATOR showWithMessage:@"Starting video..."];
        [[self.playerViewController player] seekToTime:CMTimeMake(0, 0) completionHandler:^(BOOL finished) {
            [SPMU_ACTIVITY_INDICATOR hide];
            self.videoStartedTime = [NSDate date];
            self.touchRecordingView.hidden = NO;
            [[self.playerViewController player] play];
        }];
    } else {
        // YT it is
        [self.ytPlayerView seekToSeconds:0 allowSeekAhead:YES];
        self.videoStartedTime = [NSDate date];
        [self.ytPlayerView playVideo];
        self.touchRecordingView.hidden = NO;
    }
}

-(IBAction)stopRecordTimes:(id)sender {
    self.touchRecordingView.hidden = YES;
}

-(IBAction)recordCurrentTime:(id)sender {
    if (self.recordedTimes == nil) {
        self.recordedTimes = [NSMutableArray array];
    }
    [self.recordedTimes addObject:[NSDate date]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue
                sender:(id)sender {
    BrowsePhotosVC *vc = (BrowsePhotosVC*)[segue destinationViewController];
    vc.items = [self capturedImages];
}

- (void)showCapturedImages
{
  
    BrowsePhotosController *browsePhotosController = [[BrowsePhotosController alloc] initWithImages:self.capturedImages];
    [self presentViewController:browsePhotosController animated:NO completion:nil];
}

-(IBAction)loadVideo:(id)sender {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Load Video"
                                 message:@"Select your source"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* selectAlbum = [UIAlertAction
                                    actionWithTitle:@"Album"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        self.requestedVideoSource = RequestedVideoSource_Album;
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        [self loadVideoFromAlbum];
                                    }];
    UIAlertAction* selectYoutube = [UIAlertAction
                         actionWithTitle:@"Youtube"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             self.requestedVideoSource = RequestedVideoSource_YouTube;
                             //Do some thing here
                             [view dismissViewControllerAnimated:YES completion:nil];
                             [self loadVideoFromYouTube];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [view addAction:selectAlbum];
    [view addAction:selectYoutube];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

# pragma mark - Album Video Loading

-(void)loadVideoFromAlbum {
    self.ytPlayerView.hidden = YES;
    self.playerViewController.view.hidden = NO;
    UIImagePickerController *mediaLibrary = [[UIImagePickerController alloc] init];
    mediaLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaLibrary.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    mediaLibrary.delegate = self;
    mediaLibrary.allowsEditing = NO;
    [self presentViewController:mediaLibrary animated:YES completion:NO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"here");
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    AVPlayer *player = [AVPlayer playerWithURL:url];
    self.playerViewController.player = player;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"here");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - YT Video Loading

-(void)loadVideoFromYouTube {
    self.ytPlayerView.hidden = NO;
    self.playerViewController.view.hidden = YES;
    [self performSegueWithIdentifier:@"youtube_vc" sender:self];
}

# pragma mark - YT Video Player

/**
 * Invoked when the player view is ready to receive API calls.
 *
 * @param playerView The YTPlayerView instance that has become ready.
 */
- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
}

/**
 * Callback invoked when player state has changed, e.g. stopped or started playback.
 *
 * @param playerView The YTPlayerView instance where playback state has changed.
 * @param state YTPlayerState designating the new playback state.
 */
- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    NSLog(@"[%@] - Quality changed to: %ld", NSDate.date, state);
}

/**
 * Callback invoked when playback quality has changed.
 *
 * @param playerView The YTPlayerView instance where playback quality has changed.
 * @param quality YTPlaybackQuality designating the new playback quality.
 */
- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality {
}

/**
 * Callback invoked when an error has occured.
 *
 * @param playerView The YTPlayerView instance where the error has occurred.
 * @param error YTPlayerError containing the error state.
 */
- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error {
    NSLog(@"YT Error: %@", error);
}

/**
 * Callback invoked frequently when playBack is plaing.
 *
 * @param playerView The YTPlayerView instance where the error has occurred.
 * @param playTime float containing curretn playback time.
 */
- (void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime {
    NSLog(@"Player time: %f", playTime);
}

/**
 * Callback invoked when setting up the webview to allow custom colours so it fits in
 * with app color schemes. If a transparent view is required specify clearColor and
 * the code will handle the opacity etc.
 */
- (UIColor *)playerViewPreferredWebViewBackgroundColor:(YTPlayerView *)playerView {
    return [UIColor greenColor];
}

-(void)videoSelected:(NSNotification *)notification {
    NSDictionary *videoData = (NSDictionary *)notification.object;
    NSDictionary *videoId = videoData[@"id"];
    [self.ytPlayerView loadWithVideoId:videoId[@"videoId"]];
}

@end
