//
//  FSCaptureSessionsVC.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/19/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "FSCaptureSessionsVC.h"
#import "FSUtils.h"
#import "FSCaptureSessionStore.h"

@interface FSCaptureSessionsVC ()

@end

@implementation FSCaptureSessionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newSessionCreated:)
                                                 name:NewSessionCreated object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return FSCaptureSessionStore.sharedInstance.count;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FSRecording *recording = [self.recordings objectAtIndex:indexPath.row - 1];
    FSVideo *video = recording.video;
    YTVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecordingCell" forIndexPath:indexPath];
    cell.titleLabel.text = video.title;
    cell.dateLabel.text = video.createdDateString;
    NSString *defaultPreviewImageUrl = video.defaultPreviewImageUrl;
    
    [cell.previewImageView sd_setImageWithURL:[NSURL URLWithString:defaultPreviewImageUrl]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;

}*/

-(void)newSessionCreated:(NSNotification *)data {
    NSLog(@"Called when a new session has been created.");
    FSCaptureSession *session = data.object;
    if (moments.imageCount > 0) {
        // then save it!
        [FSCaptureSessionStore.sharedInstance add:moments];
        [FSCaptureSessionStore.sharedInstance save];
        [self.tableView reloadData];
    }
}

@end
