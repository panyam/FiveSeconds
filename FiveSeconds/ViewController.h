//
//  ViewController.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/8/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet AVPlayerViewController *playerViewController;
@property (nonatomic, strong) IBOutlet UIView *containerView;

-(IBAction)takePhoto:(id)sender;
-(IBAction)startVideo:(id)sender;

@end

