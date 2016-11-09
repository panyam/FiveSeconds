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

@interface ViewController ()

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong)     AVCaptureSession *captureSession;

@end

@implementation ViewController

@synthesize startButton;
@synthesize takePhotoButton;
@synthesize pickerImageView;
@synthesize videoPlayerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initializeCamera];
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
         }
         // Continue as appropriate.
     }];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dummyFunction];
    });
    NSLog(@"Here...");
}

-(void)dummyFunction {
    NSLog(@"After 2 seconds");
}

-(IBAction)startVideo:(id)sender {
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"here");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"here");
}


@end
