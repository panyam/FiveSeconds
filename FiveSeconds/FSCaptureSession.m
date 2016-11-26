//
//  FSCaptureSession.m
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSCaptureSession.h"
#import "FSRecordingStore.h"

@interface FSCaptureSession()

@property (nonatomic) NSUInteger imageCount;

@end

@implementation FSCaptureSession

@synthesize imageCount;
@synthesize recording;
@synthesize sessionId;

-(id)initWithRecording:(FSRecording *)_recording
{
    self = [super init];
    if (self) {
        self.recording = _recording;
        sessionId = [NSString stringWithFormat:@"%lld",
                        (unsigned long long)([[NSDate date] timeIntervalSince1970] * 1000)];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.recording.recordingId forKey:@"recordingId"];
    [encoder encodeObject:self.sessionId forKey:@"sessionId"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.imageCount] forKey:@"imageCount"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder {
    NSString *recordingId = [decoder decodeObjectForKey:@"recordingId"];
    FSRecording *_recording = [FSRecordingStore.sharedInstance recordingById:recordingId];
    self = [self initWithRecording:_recording];
    NSString *ssnId = [decoder decodeObjectForKey:@"sessionId"];
    if (ssnId) {
        sessionId = [ssnId copy];
    }
    NSNumber *imgCount = [decoder decodeObjectForKey:@"imageCount"];
    if (imgCount) {
        imageCount = [imgCount integerValue];
    }
    return self;
}

- (void)saveCustomObject:(FSCaptureSession *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (FSCaptureSession *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    FSCaptureSession *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

-(NSString *)folder {
    return [self.recording.sessionsFolder stringByAppendingPathComponent:self.sessionId];
}

-(NSString *)imagesFolder {
    return [self.folder stringByAppendingPathComponent:@"Images"];
}

-(NSString *)pathForIndex:(NSUInteger)index {
    return [self.imagesFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%05ld.jpeg", index]];
}

-(void)addImage {
    self.imageCount ++;
}

@end

