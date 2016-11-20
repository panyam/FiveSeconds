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
#import "FSVideo.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newRecordingCreated:)
                                                 name:NewRecordingCreated object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + self.recordings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddRecordingCell" forIndexPath:indexPath];
        return cell;
    } else {
        NSDictionary *data = [self.recordings objectAtIndex:indexPath.row - 1];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordingCell" forIndexPath:indexPath];
        FSVideo *video = data[@"video"];
        cell.textLabel.text = video.title;
        return cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    if (indexPath.row == 0) {
        [self loadVideo];
    } else {
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
//    self.ytPlayerView.hidden = NO;
//    self.playerViewController.view.hidden = YES;
    [self performSegueWithIdentifier:@"youtube_vc" sender:self];
}

/**
 * Called when a video has been selected to start recording.
 */
-(void)newRecordingCreated:(NSNotification *)data {
    NSLog(@"Called when a new recording has been created.");
    if (self.recordings == nil)
        self.recordings = NSMutableArray.array;
    [self.recordings addObject:data.object];
    [self.tableView reloadData];
}

@end
