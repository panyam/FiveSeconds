//
//  FSYTVideo.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/20/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSYTVideo.h"
#import "FSVideoPlayer.h"

@interface FSYTVideo()

@property (nonatomic, strong) IBOutlet YTPlayerView *ytPlayerView;

@end

@implementation FSYTVideo

@synthesize ytPlayerView;

-(id)initWithVideo:(NSDictionary *)dict {
    if ((self = [super initWithVideo:dict])) {
        [self prepareControls];
    }
    return self;
}

-(void)dealloc {
    self.ytPlayerView.delegate = nil;
    [self.ytPlayerView removeFromSuperview];
    self.ytPlayerView = nil;
}

-(FSVideoSource)source {
    return FSVideoSourceYouTube;
}

-(NSString *)title {
    return self.metadata[@"snippet"][@"title"];
}

-(NSString *)description {
    return self.metadata[@"description"];
}

-(NSString *)createdDateString {
    return self.metadata[@"snippet"][@"publishedAt"];
}

-(NSString *)defaultPreviewImageUrl {
    return self.metadata[@"snippet"][@"thumbnails"][@"default"][@"url"];
}

-(void)prepareControls {
    self.ytPlayerView = [[YTPlayerView alloc] init];
    self.ytPlayerView.delegate = self;
}

-(void)preparePlayer:(FSVideoPlayer *)player {
    [super preparePlayer:player];
    if (!self.ytPlayerView) {
        [self prepareControls];
    }
    NSDictionary *videoId = self.metadata[@"id"];
    self.ytPlayerView.webView.allowsInlineMediaPlayback = YES;
    NSDictionary *playerVars = @{@"playsinline": @1,};
    [self.ytPlayerView loadWithVideoId:videoId[@"videoId"] playerVars:playerVars];
    UIWindow *window = self.currentPlayer.playerWindow;
    window.rootViewController = [[UIViewController alloc] init];
    [window.rootViewController.view addSubview:self.ytPlayerView];
    self.ytPlayerView.frame = window.bounds;
}

-(void)playFromOffset:(NSTimeInterval)offset {
    [self seekOffset:offset onCompletion:^(id result, NSError *error) {
        [self.ytPlayerView playVideo];
    }];
}

-(void)seekOffset:(NSTimeInterval)offset onCompletion:(FSCallback)handler {
    if (offset >= 0)
        [self.ytPlayerView seekToSeconds:0 allowSeekAhead:YES];
    if (handler) {
        handler(nil, nil);
    }
}

-(void)stop {
    [self.ytPlayerView pauseVideo];
}

-(NSTimeInterval)offset {
    return self.ytPlayerView.currentTime;
}

# pragma mark - YT Video Player

/**
 * Invoked when the player view is ready to receive API calls.
 *
 * @param playerView The YTPlayerView instance that has become ready.
 */
- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
}

/**
 * Callback invoked when player state has changed, e.g. stopped or started playback.
 *
 * @param playerView The YTPlayerView instance where playback state has changed.
 * @param state YTPlayerState designating the new playback state.
 */
- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    NSLog(@"[%@] - Quality changed to: %ld", NSDate.date, state);
}

/**
 * Callback invoked when playback quality has changed.
 *
 * @param playerView The YTPlayerView instance where playback quality has changed.
 * @param quality YTPlaybackQuality designating the new playback quality.
 */
- (void)playerView:(YTPlayerView *)playerView didChangeToQuality:(YTPlaybackQuality)quality {
}

/**
 * Callback invoked when an error has occured.
 *
 * @param playerView The YTPlayerView instance where the error has occurred.
 * @param error YTPlayerError containing the error state.
 */
- (void)playerView:(YTPlayerView *)playerView receivedError:(YTPlayerError)error {
    NSLog(@"YT Error: %ld", (long)error);
}

/**
 * Callback invoked frequently when playBack is plaing.
 *
 * @param playerView The YTPlayerView instance where the error has occurred.
 * @param playTime float containing curretn playback time.
 */
- (void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime {
}

/**
 * Callback invoked when setting up the webview to allow custom colours so it fits in
 * with app color schemes. If a transparent view is required specify clearColor and
 * the code will handle the opacity etc.
 */
- (UIColor *)playerViewPreferredWebViewBackgroundColor:(YTPlayerView *)playerView {
    return [UIColor greenColor];
}

# pragma mark -
# pragma mark - Encoder/Decoder methods

- (id)initWithCoder:(NSCoder *)decoder {
    return [self initWithVideo:[decoder decodeObjectForKey:@"metadata"]];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.metadata forKey:@"metadata"];
}

@end
