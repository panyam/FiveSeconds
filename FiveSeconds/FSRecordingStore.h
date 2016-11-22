//
//  FSRecordingStore.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSRecording.h"

@interface FSRecordingStore : NSObject

+(FSRecordingStore *)sharedInstance;
-(void)load;
-(void)save;
-(void)add:(FSRecording *)recording;
-(FSRecording *)recordingAtIndex:(NSInteger)index;
-(FSRecording *)recordingById:(NSString *)recordingId;
-(NSUInteger)count;

@end
