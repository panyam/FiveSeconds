//
//  YTSearchVC.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/10/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SPiOSUtils/SPMobileUtils.h>

@class YTSearchVC;
@class FSVideo;

typedef void (^YTVideoSelectedCallback)(YTSearchVC *vc, FSVideo *video);

@interface YTSearchVC : UITableViewController<UISearchBarDelegate>

@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchController *searchController;
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
@property (nonatomic, copy) NSString *searchTerm;
@property (nonatomic, copy) YTVideoSelectedCallback videoSelectedCallback;

@end
