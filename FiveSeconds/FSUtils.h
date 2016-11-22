//
//  FSUtils.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/13/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//


#ifndef __FS__UTILS__H__
#define __FS__UTILS__H__

#import <Foundation/Foundation.h>

#define VideoSelectedNotification   @"VideoSelected"
#define NewRecordingCreated         @"NewRecordingCreated"
#define NewSessionCreated           @"NewSessionCreated"

typedef void (^FSCallback)(id result, NSError *error);

#if TARGET_IPHONE_SIMULATOR
#define DEFAULT_CACHE_DIRECTORY   NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSLocalDomainMask, YES)
#else
#define DEFAULT_CACHE_DIRECTORY   NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
#endif

#endif
