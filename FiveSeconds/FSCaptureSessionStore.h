//
//  FSCaptureSessionStore.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSCapturedMoments.h"

@interface FSCaptureSessionStore : NSObject

+(FSCaptureSessionStore *)sharedInstance;
-(FSCapturedMoments *)newMomentsForRecording:(FSRecording *)recording;
-(NSUInteger)count;
-(FSCapturedMoments *)sessionAtIndex:(NSInteger)index;
-(FSCapturedMoments *)sessionById:(NSString *)sessionId;
-(void)load;
-(void)save;
-(void)add:(FSCapturedMoments *)session;

@end
