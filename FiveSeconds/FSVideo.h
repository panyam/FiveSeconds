//
//  FSVideoSource.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/19/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FSUtils.h"

typedef enum FSVideoSource {
    FSVideoSourceAlbum,
    FSVideoSourceYouTube
} FSVideoSource;

@class FSVideoPlayer;

@interface FSVideo : NSObject

@property (nonatomic, readonly) NSDictionary *metadata;

@property (nonatomic, copy) NSURL *videoURL;
@property (nonatomic) FSVideoSource source;

@property (nonatomic, copy) NSString *videoID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *createdDateString;
@property (nonatomic, copy) NSString *defaultPreviewImageUrl;
@property (nonatomic) NSTimeInterval offset;


@property (nonatomic, readonly, weak) FSVideoPlayer *currentPlayer;

-(id)initWithVideo:(NSDictionary *)metadata;
-(void)preparePlayer:(FSVideoPlayer *)player;
-(void)releasePlayer:(FSVideoPlayer *)player;

-(void)playFromOffset:(NSTimeInterval)offset;
-(void)seekOffset:(NSTimeInterval)offset onCompletion:(FSCallback)handler;
-(void)stop;

@end

@interface FSAlbumVideo : FSVideo
@end
