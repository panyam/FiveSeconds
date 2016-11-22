//
//  FSCapturedMoments.m
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSCapturedMoments.h"
#import "FSRecording.h"

@implementation FSCapturedMoments

@synthesize recording;
@synthesize images;


-(id)initWithRecording:(FSRecording *)_recording
         withImageUrls:(NSArray<NSURL *> *)_images
{
    self = [super init];
    if (self) {
        self.images = _images;
        self.recording = _recording;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.recording forKey:@"recording"];
    [encoder encodeObject:self.images forKey:@"images"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder {
    return [self initWithRecording:[decoder decodeObjectForKey:@"recording"]
                   withImageUrls:[decoder decodeObjectForKey:@"images"]];
}

- (void)saveCustomObject:(FSCapturedMoments *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (FSCapturedMoments *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    FSCapturedMoments *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end

