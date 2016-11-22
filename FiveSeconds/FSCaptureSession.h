//
//  FSCaptureSession.h
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSRecording.h"

@interface FSCaptureSession : NSObject<NSCoding>

-(id)initWithRecording:(FSRecording *)_recording;

@property (nonatomic, readonly) NSString *sessionId;

-(void)addImage;
-(NSUInteger)imageCount;
-(NSString *)folder;
-(NSString *)imagesFolder;
-(NSString *)pathForIndex:(NSUInteger)index;

@end

