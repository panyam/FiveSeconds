//
//  ViewController.m
//  StoryboardExample
//
//  Created by Nick Lockwood on 08/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrowsePhotosVC.h"
#import "FbSharing.h"
#import "FSCaptureSessionStore.h"

@interface BrowsePhotosVC ()

@property (nonatomic, strong) FbSharing *fbSharing;

@end

@implementation BrowsePhotosVC

@synthesize carousel;
@synthesize items;
@synthesize fbSharing;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    fbSharing = [[FbSharing init] alloc];
    
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    
    FSCaptureSession* captureSession = [[FSCaptureSessionStore sharedInstance] sessionAtIndex:_sessionId];
    self.items = [NSMutableArray array];

    for(int i = 0; i < captureSession.imageCount; i++) {
        NSURL *url = [NSURL fileURLWithPath:[captureSession pathForIndex:i]];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        [items addObject: image];
    }
}

-(IBAction)shareOnFacebook:(id)sender {
    //    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.delegate = self;
    //    picker.allowsEditing = YES;
    //    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //    picker.showsCameraControls = NO;
    //
    //    [self presentViewController:picker animated:YES completion:NULL];
    UIView* image = [[self carousel] currentItemView];
    [fbSharing shareImage:image fromVC:self];
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    carousel.delegate = nil;
    carousel.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //configure carousel
    carousel.type = iCarouselTypeCoverFlow2;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //free up memory by releasing subviews
    self.carousel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        ((UIImageView *)view).image = self.items[index];
        view.contentMode = UIViewContentModeCenter;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
    }
    
    //set item label
    //remember to always set any properties of your carousel item
    //views outside of the `if (view == nil) {...}` check otherwise
    //you'll get weird issues with carousel item content appearing
    //in the wrong place in the carousel
    //label.text = [items[index] stringValue];
    
    return view;
}

@end
