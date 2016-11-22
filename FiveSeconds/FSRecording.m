//
//  FSRecording.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/20/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSRecording.h"

@implementation FSRecording

@synthesize video;
@synthesize offsets;


-(id)initWithVideo:(FSVideo *)_video
       withOffsets:(NSArray *)_offsets
{
    self = [super init];
    if (self) {
        self.video = _video;
        self.offsets = _offsets;
        _recordingId = (unsigned long long)([[NSDate date] timeIntervalSince1970] * 1000);
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    FSRecording *out = [self initWithVideo:[decoder decodeObjectForKey:@"video"]
                               withOffsets:[decoder decodeObjectForKey:@"offsets"]];
    NSNumber *recId = [decoder decodeObjectForKey:@"recordingId"];
    if (recId) {
        _recordingId = [recId unsignedLongLongValue];
    }
    return out;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.offsets forKey:@"offsets"];
    [encoder encodeObject:self.video forKey:@"video"];
    [encoder encodeObject:[NSNumber numberWithUnsignedLongLong:self.recordingId] forKey:@"recordingId"];
}

- (void)saveCustomObject:(FSRecording *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (FSRecording *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    FSRecording *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end
