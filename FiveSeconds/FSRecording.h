//
//  FSRecording.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/20/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSVideo.h"

@interface FSRecording : NSObject<NSCoding>

-(id)initWithVideo:(FSVideo *)_video
       withOffsets:(NSArray *)_offsets;

@property (nonatomic, readonly) unsigned long long recordingId;
@property (nonatomic, strong) FSVideo *video;
@property (nonatomic, copy) NSArray *offsets;

@end
