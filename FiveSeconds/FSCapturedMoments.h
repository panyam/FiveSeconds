//
//  FSCapturedMoments.h
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSRecording.h"

@interface FSCapturedMoments : NSObject<NSCoding>

-(id)initWithRecording:(FSRecording *)_recording
       withImageUrls:(NSArray<NSURL *> *)_images;

@property (nonatomic, strong) FSRecording *recording;
@property (nonatomic, copy) NSArray<NSURL *> *images;

@end

