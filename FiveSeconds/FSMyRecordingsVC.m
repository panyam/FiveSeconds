//
//  FSMyRecordingsVC.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/19/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSMyRecordingsVC.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "FSVideo.h"
#import "FSRecording.h"
#import "YTVideoCell.h"
#import "YTVideosVC.h"
#import "YTSearchVC.h"
#import "FSVideoPlayer.h"
#import "FSVideoPlayerControls.h"

typedef enum {
    RequestedVideoSource_Album,
    RequestedVideoSource_YouTube,
} RequestedVideoSource;

@interface FSMyRecordingsVC ()

@property (nonatomic, strong) NSMutableArray *recordings;
@property (nonatomic) RequestedVideoSource requestedVideoSource;

@end

@implementation FSMyRecordingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadRecordings];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRecordingCreated:)
                                                 name:NewRecordingCreated object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + self.recordings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddRecordingCell" forIndexPath:indexPath];
        return cell;
    } else {
        FSRecording *recording = [self.recordings objectAtIndex:indexPath.row - 1];
        FSVideo *video = recording.video;
        YTVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordingCell" forIndexPath:indexPath];
        cell.titleLabel.text = video.title;
        cell.dateLabel.text = video.createdDateString;
        NSString *defaultPreviewImageUrl = video.defaultPreviewImageUrl;
        
        [cell.previewImageView sd_setImageWithURL:[NSURL URLWithString:defaultPreviewImageUrl]
                                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 50;
    }
    return 120;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    if (indexPath.row == 0) {
        [self loadVideo];
    } else {
        [self capturePhotos];
    }
}

-(IBAction)loadVideo {
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:@"Load Video"
                                 message:@"Select your source"
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* selectAlbum = [UIAlertAction
                                  actionWithTitle:@"Album"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      self.requestedVideoSource = RequestedVideoSource_Album;
                                      //Do some thing here
                                      [view dismissViewControllerAnimated:YES completion:nil];
                                      [self loadVideoFromAlbum];
                                  }];
    UIAlertAction* selectYoutube = [UIAlertAction
                                    actionWithTitle:@"Youtube"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        self.requestedVideoSource = RequestedVideoSource_YouTube;
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        [self loadVideoFromYouTube];
                                    }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [view addAction:selectAlbum];
    [view addAction:selectYoutube];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

# pragma mark - Album Video Loading

-(void)loadVideoFromAlbum {
//    self.ytPlayerView.hidden = YES;
//    self.playerViewController.view.hidden = NO;
    UIImagePickerController *mediaLibrary = [[UIImagePickerController alloc] init];
    mediaLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    mediaLibrary.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    mediaLibrary.delegate = self;
    mediaLibrary.allowsEditing = NO;
    [self presentViewController:mediaLibrary animated:YES completion:NO];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"here");
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    // Do something with the URL
    NSLog(@"URL Selectedion: %@", url);
//    AVPlayer *player = [AVPlayer playerWithURL:url];
//    self.playerViewController.player = player;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"here");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - YT Video Loading

-(void)loadVideoFromYouTube {
    [self performSegueWithIdentifier:@"youtube_vc" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    YTVideosVC *vc = (YTVideosVC *)[segue destinationViewController];
    YTSearchVC *searchVC = [vc.viewControllers objectAtIndex:0];
    searchVC.videoSelectedCallback = ^(YTSearchVC *vc, FSVideo *video) {
        FSVideoPlayer.sharedInstance.currentVideo = video;
        FSVideoPlayer.sharedInstance.controls = [[FSOffsetsRecorderControlsVC alloc] init];
        FSVideoPlayer.sharedInstance.controls.callback = ^(NSObject<FSVideoPlayerControls> *sender, NSString *action, NSObject *actionData) {
            return [self handleAction:action forControls:sender withData:actionData];
        };
        [FSVideoPlayer.sharedInstance show];
    };
}

/**
 * Called when a video has been selected to start recording.
 */
-(void)newRecordingCreated:(NSNotification *)data {
    NSLog(@"Called when a new recording has been created.");
    if (self.recordings == nil)
        self.recordings = NSMutableArray.array;
    [self.recordings insertObject:data.object atIndex:0];
    [self saveRecordings];
    [self.tableView reloadData];
}

-(void)saveRecordings {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.recordings]
                                              forKey:@"FSMyrecordingsVC.recordings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)loadRecordings {
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"FSMyrecordingsVC.recordings"];
    if (dataRepresentingSavedArray != nil)
    {
        NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
        if (oldSavedArray != nil)
            self.recordings = [oldSavedArray mutableCopy];
        else
            self.recordings = [[NSMutableArray alloc] init];
    }
}

# pragma mark - Photo Capturing
-(void)capturePhotos {
}


#pragma mark -
#pragma mark - Video Player controls

// TODO - Make YTSearch have a "videoSelected" delegate and put this stuff in there
// instead of having to do recording stuff here!
-(BOOL)handleAction:(NSString *)action
        forControls:(NSObject<FSVideoPlayerControls> *)sender
           withData:(id)actionData {
    FSOffsetsRecorderControlsVC *offsetsRecorderVC = (FSOffsetsRecorderControlsVC *)sender;
    FSVideoPlayer *player = FSVideoPlayer.sharedInstance;
    
    if ([action isEqualToString:@"close"]) {
        if (offsetsRecorderVC.recordedOffsets.count > 0) {
            // then we have a new touch
            FSRecording *recording = [[FSRecording alloc] initWithVideo:player.currentVideo
                                                            withOffsets:offsetsRecorderVC.recordedOffsets];
            [[NSNotificationCenter defaultCenter] postNotificationName:NewRecordingCreated object:recording];
        }
        offsetsRecorderVC.playBarButtonItem.title = @"Play";
        [FSVideoPlayer.sharedInstance hide];
        return YES;
    }
    else if ([action isEqualToString:@"play"]) {
        UIBarButtonItem *item = actionData;
        [player.currentVideo playFromOffset:-1];
        item.title = @"Pause";
        item.enabled = YES;
        return YES;
    }
    else if ([action isEqualToString:@"pause"]) {
        UIBarButtonItem *item = actionData;
        [player.currentVideo stop];
        item.title = @"Play";
        item.enabled = YES;
        return YES;
    }
    else if ([action isEqualToString:@"restart"]) {
        [player.currentVideo seekOffset:0 onCompletion:^(id result, NSError *error) {
            UIBarButtonItem *item = actionData;
            item.enabled = YES;
        }];
        return YES;
    }
    return NO;
}

@end
