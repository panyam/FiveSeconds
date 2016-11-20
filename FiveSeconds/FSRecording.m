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
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    return [self initWithVideo:[decoder decodeObjectForKey:@"video"]
                   withOffsets:[decoder decodeObjectForKey:@"offsets"]];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.offsets forKey:@"offsets"];
    [encoder encodeObject:self.video forKey:@"video"];
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
