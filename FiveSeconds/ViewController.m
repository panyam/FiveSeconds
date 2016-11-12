//
//  ViewController.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/8/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>

typedef enum {
    RequestedVideoSource_Album,
    RequestedVideoSource_YouTube,
} RequestedVideoSource;

@interface ViewController ()

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureSession *captureSession;

@property (nonatomic) RequestedVideoSource requestedVideoSource;

@end

@implementation ViewController

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

-(IBAction)capturePhotos:(id)sender {
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    picker.showsCameraControls = NO;
//    
//    [self presentViewController:picker animated:YES completion:NULL];

    [self captureVideoAfter:2];
    [self captureVideoAfter:4];
    [self captureVideoAfter:6];
}

-(void)captureVideoAfter:(NSTimeInterval)time_in_seconds {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time_in_seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Taking Photo At: %@", [NSDate date]);
        for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
            for (AVCaptureInputPort *port in [connection inputPorts]) {
                if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                    self.videoConnection = connection;
                    break;
                }
            }
            if (self.videoConnection) { break; }
        }
        
        __weak typeof(self) weakSelf = self;
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:self.videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
            CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
            if (exifAttachments) {
                // Do something with the attachments.
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                NSLog(@"Done Taking Photo At: %@", [NSDate date]);
            }
            // Continue as appropriate.
        }];
    });
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

@end
