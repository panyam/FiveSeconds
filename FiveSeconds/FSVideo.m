//
//  FSVideoSource.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/19/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreGraphics/CoreGraphics.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "FSVideoPlayer.h"

@interface FSVideo ()

@property (nonatomic, weak) FSVideoPlayer *currentPlayer;

@end

@implementation FSVideo

@synthesize currentPlayer;
@synthesize videoURL;
@synthesize source;

@synthesize videoID;
@synthesize title;
@synthesize description;
@synthesize createdDateString;
@synthesize metadata;

-(id)initWithVideo:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        metadata = [dict mutableCopy];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    return [self initWithVideo:[decoder decodeObjectForKey:@"metadata"]];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.metadata forKey:@"metadata"];
}

-(void)preparePlayer:(FSVideoPlayer *)player {
    self.currentPlayer = player;
}

-(void)releasePlayer:(FSVideoPlayer *)player {
    [self stop];
    self.currentPlayer = nil;
}

-(void)playFromOffset:(NSTimeInterval)offset {}
-(void)seekOffset:(NSTimeInterval)offset onCompletion:(FSCallback)handler {}
-(void)stop {}

@end

@interface FSAlbumVideo()
@property (nonatomic, strong) IBOutlet AVPlayerViewController *playerViewController;
@end


@implementation FSAlbumVideo

@synthesize playerViewController;

-(id)initWithVideo:(NSDictionary *)dict {
    if ((self = [super initWithVideo:dict])) {
        self.playerViewController = [[AVPlayerViewController alloc] init];
        AVPlayer *player = [AVPlayer playerWithURL:self.videoURL];
        self.playerViewController.player = player;
    }
    return self;
}

-(void)dealloc {
    self.playerViewController.player = nil;
    self.playerViewController = nil;
}

-(FSVideoSource)source {
    return FSVideoSourceAlbum;
}

-(void)preparePlayer:(FSVideoPlayer *)player {
    [super preparePlayer:player];
    if (!self.playerViewController) {
        self.playerViewController = [[AVPlayerViewController alloc] init];
        AVPlayer *player = [AVPlayer playerWithURL:self.videoURL];
        self.playerViewController.player = player;
    }
    player.playerWindow.rootViewController = self.playerViewController;
}

-(void)releaseWindow:(UIWindow *)window {
    self.playerViewController.player = nil;
    self.playerViewController = nil;
}

-(void)playFromOffset:(NSTimeInterval)offset {
    [self seekOffset:offset onCompletion:^(id result, NSError *error) {
        [[self.playerViewController player] play];
    }];
}

-(void)seekOffset:(NSTimeInterval)offset onCompletion:(FSCallback)handler {
    [[self.playerViewController player] seekToTime:CMTimeMake(0, 0) completionHandler:^(BOOL finished) {
        if (handler) {
            handler(nil, nil);
        }
    }];
}

-(void)stop {
    [[[self playerViewController] player] pause];
}

# pragma mark -
# pragma mark - Encoder/Decoder methods

- (void)saveCustomObject:(FSVideo *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (FSVideo *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    FSVideo *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end
