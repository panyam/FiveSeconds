//
//  FSMomentsCaptureControlsVC.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "FSMomentsCaptureControlsVC.h"
#import "FSVideoPlayer.h"
#import "FSCaptureSessionStore.h"

@interface FSMomentsCaptureControlsVC()

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, copy) NSString *recordingDir;
@property (nonatomic, copy) NSString *imagesDir;
@property (nonatomic) NSInteger offsetIndex;
@property (nonatomic, strong) NSMutableArray *imageURLs;
@property (nonatomic, strong) FSCaptureSession *currentSession;

@end

@implementation FSMomentsCaptureControlsVC

@synthesize stillImageOutput;
@synthesize videoConnection;
@synthesize captureSession;

@synthesize captureBarButtonItem;
@synthesize player;
@synthesize callback;
@synthesize offsetIndex;
@synthesize imageURLs;

-(void)viewDidLoad {
    [super viewDidLoad];
    [self initializeCamera];
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

-(IBAction)closeButtonClicked {
    if (self.callback) {
        self.callback(self, @"close", nil);
    }
}

-(IBAction)captureButtonClicked:(_Nonnull id)sender {
    if (self.callback) {
        self.captureBarButtonItem.enabled = NO;
        [self startCaptureSession];
    }
}

-(NSUInteger)numCaptured {
    return self.imageURLs.count;
}

-(void)startCaptureSession {
    // First ensure the recording specific image folder is empty and clear
    if (!self.recording.recordingId) {
        return ;
    }
    self.recordingDir = self.recording.folder;
    self.imagesDir = [self.recordingDir stringByAppendingPathComponent:@"Images"];

    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:self.imagesDir error:&error];
    if (error) {
        NSLog(@"Error removing images directory: %@", error);
        error = nil;
    }

    [[NSFileManager defaultManager] createDirectoryAtPath:self.imagesDir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    NSAssert(error == nil, @"Error creating images directory");
    
    // Now we are safe to start taking snapshots
    [self.player.currentVideo playFromOffset:0];
    self.currentSession = [FSCaptureSessionStore.sharedInstance newSessionForRecording:self.recording];
    self.offsetIndex = 0;
    [self trackNextOffset];
}

-(void)trackNextOffset {
    if (self.offsetIndex >= self.recording.offsets.count) {
        NSLog(@"Tracking complete.  No more offsets left");

        // we are done with all photos so quit
        if (self.callback)
            self.callback(self, @"captured", nil);
        return;
    }
    
    NSNumber *currOffset = [self.recording.offsets objectAtIndex:self.offsetIndex];
    NSString *remainingOffsets = [self.recording.offsets componentsJoinedByString:@", "];
    NSLog(@"Tracking offset, curr video time: %@, Offsets Remaining: %@", currOffset, remainingOffsets);
    NSTimeInterval currVideoTime = self.player.currentVideo.offset;
    NSTimeInterval nextTime = [currOffset doubleValue];
    double SNAP_DELTA = 0.01;   // 10 milliseconds is "close" enough
    if (currVideoTime > nextTime || nextTime - currVideoTime < SNAP_DELTA) {
        // for some reason this elapsed so take the photo
        [self captureVideoForIndex:self.offsetIndex onCompletion:^(id result, NSError *error) {
            self.offsetIndex += 1;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self trackNextOffset];
            });
        }];
    } else {
        // The next video is "too far" from current time, so track again but after "half time".  ie
        // at each iteration we jump half the distance to next offset till we get close!
        NSTimeInterval delay = (nextTime - currVideoTime) / 2.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self trackNextOffset];
        });
    }
}

-(void)captureVideoForIndex:(NSInteger)index onCompletion:(FSCallback)completion {
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
        if (error) {
            if (completion) {
                completion(nil, error);
                return ;
            }
        } else {
            CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
            if (exifAttachments) {
                // Do something with the attachments.
                NSString *filepath = [self.currentSession pathForIndex:index];
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
                [imageData writeToFile:filepath atomically:NO];
                [self.currentSession addImage];
                NSLog(@"Saving photo %ld to file: %@", index, filepath);
                [self.imageURLs addObject:[NSURL fileURLWithPath:filepath]];
                if (completion) {
                    completion(nil, error);
                }
            }
            // Continue as appropriate.
        }
    }];
}

@end
