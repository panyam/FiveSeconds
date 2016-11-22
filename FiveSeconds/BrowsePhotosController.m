//
//  BrowsePhotosController.m
//  FiveSeconds
//
//  Created by Akshat Bhatia on 11/13/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iCarousel/iCarousel.h>
#import "BrowsePhotosController.h"
#import "FbSharing.h"

@interface BrowsePhotosController ()


@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) UINavigationItem *navItem;
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;

@end


@implementation BrowsePhotosController


- (instancetype)initWithImages:(NSArray<UIImage *> *)images
{
    self = [super init];
    if (self) {
        self.images = [images mutableCopy];
        [self.view addSubview:_carousel];

    }
    return self;
}

- (void)dealloc
{
    //it's a good idea to set these to nil here to avoid
    //sending messages to a deallocated viewcontroller
    //this is true even if your project is using ARC, unless
    //you are targeting iOS 5 as a minimum deployment target
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //add background
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.image = [UIImage imageNamed:@"background.png"];
    [self.view addSubview:backgroundView];
    
    //create carousel
    _carousel = [[iCarousel alloc] initWithFrame:self.view.bounds];
    _carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _carousel.type = iCarouselTypeLinear;
    _carousel.delegate = self;
    _carousel.dataSource = self;
    
    //add carousel to view
    [self.view addSubview:_carousel];
    
    //add top bar
    UINavigationBar *navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navItem = [[UINavigationItem alloc] initWithTitle:@"Your photos"];
   
    [navbar setItems:@[_navItem]];
    [self.view addSubview:navbar];
    
    //add bottom bar
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [toolbar setItems:@[[[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(share)],
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL],
                        [[UIBarButtonItem alloc] initWithTitle:@"Delete Item" style:UIBarButtonItemStylePlain target:self action:@selector(removeItem:)]]];
    [self.view addSubview:toolbar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
    self.navItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)share:(id)sender
{
    NSInteger index = _carousel.currentItemIndex;
    FbSharing *fbSharing = [[FbSharing alloc] init];
    [fbSharing shareImage:self.images[index] fromVC:self];
}

- (void)removeItem:(id)sender
{
    if (_carousel.numberOfItems > 0)
    {
        NSInteger index = _carousel.currentItemIndex;
        [_carousel removeItemAtIndex:index animated:YES];
        [_images removeObjectAtIndex:index];
    }
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_images count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        ((UIImageView *)view).image = self.images[index];
        view.contentMode = UIViewContentModeScaleAspectFit;
    }
  
    return view;
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

@end
