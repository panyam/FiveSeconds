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
#import "FSCaptureSessionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FSCapturedMomentCell.h"

@interface FSCaptureSessionsVC ()

@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;

@end

@implementation FSCaptureSessionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newSessionCreated:)
                                                 name:NewSessionCreated object:nil];
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return FSCaptureSessionStore.sharedInstance.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CaptureSessionCell";
    FSCaptureSession *captureSession = [FSCaptureSessionStore.sharedInstance sessionAtIndex:indexPath.row];
    FSRecording *recording = captureSession.recording;
    FSVideo *video = recording.video;
    FSCaptureSessionCell* captureCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    captureCell.dateTakenLabel.text = captureSession.sessionId;
    captureCell.sessionId = captureSession.sessionId;
    NSString *defaultPreviewImageUrl = video.defaultPreviewImageUrl;
    [captureCell.previewImageView sd_setImageWithURL:[NSURL URLWithString:defaultPreviewImageUrl]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return captureCell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(FSCaptureSessionCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

# pragma mark - Collection view data source
#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger row = [[(AFIndexedCollectionView*) collectionView indexPath] row];
    FSCaptureSession *captureSession = [[FSCaptureSessionStore sharedInstance] sessionAtIndex:row];

    return captureSession.imageCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [[(AFIndexedCollectionView*) collectionView indexPath] row];
    FSCaptureSession *captureSession = [[FSCaptureSessionStore sharedInstance] sessionAtIndex:row];
    
    FSCapturedMomentCell *cell = (FSCapturedMomentCell*)[collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    NSURL *url = [NSURL fileURLWithPath:[captureSession pathForIndex:indexPath.item]];
    
    [cell.imageView sd_setImageWithURL:url
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}

-(void)newSessionCreated:(NSNotification *)data {
    NSLog(@"Called when a new session has been created.");
    FSCaptureSession *session = data.object;
    if (session.imageCount > 0) {
        // then save it!
        [FSCaptureSessionStore.sharedInstance add:session];
        [FSCaptureSessionStore.sharedInstance save];
        [self.tableView reloadData];
    }
}

@end
