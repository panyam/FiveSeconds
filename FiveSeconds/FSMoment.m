//
//  FSMoment.m
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSMoment.h"
#import "FSRecording.h"

@implementation FSMoment

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

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder {
    return [self initWithRecording:[decoder decodeObjectForKey:@"recording"]
                   withImageUrls:[decoder decodeObjectForKey:@"images"]];
}

@end

