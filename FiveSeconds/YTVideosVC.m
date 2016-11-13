//
//  YTVideosVC.m
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/13/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import "YTVideosVC.h"
#import "FSUtils.h"

@interface YTVideosVC ()

@end

@implementation YTVideosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoSelected:)
                                                 name:VideoSelectedNotification object:nil];
}

-(void)videoSelected:(NSObject *)data {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VideoSelectedNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
