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

@interface ViewController ()

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@end

@implementation ViewController

@synthesize toolbar;

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.playerViewController = [[AVPlayerViewController alloc] init];
    [self addChildViewController:self.playerViewController];
    [self.containerView addSubview:self.playerViewController.view];
    [self initializeCamera];
}

-(void)viewDidAppear:(BOOL)animated {
    CGRect ourFrame = self.view.frame;
    CGRect toolbarFrame = self.toolbar.frame;
    CGSize containerSize = self.containerView.frame.size;
    self.playerViewController.view.frame = CGRectMake(0,0, containerSize.width, containerSize.height);
    [super viewDidAppear:animated];
}

-(void)initializeCamera {
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)takePhoto:(id)sender {    
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

-(void)photoSaved {
    NSLog(@"After 2 seconds");
}


-(IBAction)loadVideo:(id)sender {
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

@end
