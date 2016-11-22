//
//  FSCaptureSessionStore.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/21/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSCaptureSession.h"

@interface FSCaptureSessionStore : NSObject

+(FSCaptureSessionStore *)sharedInstance;
-(FSCaptureSession *)newSessionForRecording:(FSRecording *)recording;
-(NSUInteger)count;
-(FSCaptureSession *)sessionAtIndex:(NSInteger)index;
-(FSCaptureSession *)sessionById:(NSString *)sessionId;
-(void)load;
-(void)save;
-(void)add:(FSCaptureSession *)session;

@end
