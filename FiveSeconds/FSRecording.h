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

@property (nonatomic, readonly) NSString *recordingId;
@property (nonatomic, strong) FSVideo *video;
@property (nonatomic, copy) NSArray *offsets;
@property (nonatomic, readonly) NSString *folder;
@property (nonatomic, readonly) NSString *sessionsFolder;
@end
