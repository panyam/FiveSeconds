//
//  YTSearchVC.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/10/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "YTSearchVC.h"
#import "YTVideoCell.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "FSVideoPlayer.h"
#import "FSYTVideo.h"

@interface YTSearchVC ()

@property (nonatomic) NSInteger appearCount;
@property (nonatomic,strong) AFURLSessionManager *manager;
@property (nonatomic, copy) NSArray *videos;
@end

@implementation YTSearchVC

@synthesize searchBar;
@synthesize videos;
@synthesize searchController;
@synthesize appearCount;
@synthesize searchTerm;
@synthesize manager;

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.appearCount == 0) {
        [self reloadData];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    self.appearCount ++;
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchTerm = [[NSUserDefaults standardUserDefaults] valueForKey:@"YTSearchVC.searchTerm"];
    if (self.searchTerm == nil) self.searchTerm = @"";
    self.searchBar.text = self.searchTerm;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.tableView.tableHeaderView = self.searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadData {
    [[NSUserDefaults standardUserDefaults] setValue:self.searchTerm forKey:@"YTSearchVC.searchTerm"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *urlTemplate = @"https://www.googleapis.com/youtube/v3/search?part=snippet&key=AIzaSyAAJ9pGNzoAGAhvHTSJA2YjIgO4EAs_W5M&maxResults=50&q=";
    NSString *escapedQuery = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                   NULL,
                                                                                                   (CFStringRef)self.searchTerm,
                                                                                                   NULL,
                                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                   kCFStringEncodingUTF8 ));
    NSURL *url = [NSURL URLWithString:[urlTemplate stringByAppendingString:escapedQuery]];
    if (searchTerm.length == 0) {
        [SPMU_ACTIVITY_INDICATOR showWithMessage:@"Searching top videos..."];
    } else {
        [SPMU_ACTIVITY_INDICATOR showWithMessage:[NSString stringWithFormat:@"Searching videso for '%@' ...", self.searchTerm]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            dispatch_to_main_queue(^{
                self.videos = [responseObject objectForKey:@"items"];
                [self.tableView reloadData];
                [SPMU_ACTIVITY_INDICATOR hide];
            });
        }
    }];
    [dataTask resume];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.videos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *videoData = [[self.videos objectAtIndex:indexPath.row] objectForKey:@"snippet"];
    YTVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YTVideoCell"];
    NSString *title = videoData[@"title"];
    NSString *dateString = videoData[@"publishedAt"];
    NSDictionary *thumbnails = videoData[@"thumbnails"];
    NSDictionary *defaultPreviewImage = thumbnails[@"default"];

    cell.titleLabel.text = title;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
//    [formatter dateFromString:dateString];
    cell.dateLabel.text = dateString;

    [cell.previewImageView sd_setImageWithURL:[NSURL URLWithString:defaultPreviewImage[@"url"]]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *videoData = [self.videos objectAtIndex:indexPath.row];
    FSVideoPlayer.sharedInstance.currentVideo = [[FSYTVideo alloc] initWithVideo:videoData];
    [FSVideoPlayer.sharedInstance show];
//    [[NSNotificationCenter defaultCenter] postNotificationName:VideoSelectedNotification object:videoData];
}

#pragma mark - Search bar delegate

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar;                      // return NO to not become first responder
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;                     // called when text starts editing
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.searchTerm = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sb {
    [sb endEditing:YES];
}

@end
