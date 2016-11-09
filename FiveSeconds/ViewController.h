//
//  ViewController.h
//  FiveSeconds
//
//  Created by Sriram Panyam on 11/8/16.
//  Copyright © 2016 Hackery Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIImageView *pickerImageView;
@property (strong, nonatomic) IBOutlet UIView *videoPlayerView;

-(IBAction)takePhoto:(id)sender;
-(IBAction)startVideo:(id)sender;

@end

