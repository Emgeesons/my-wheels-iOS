//
//  DisclaimerViewController.h
//  CrimeStopper
//
//  Created by Asha Sharma on 05/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"

@interface DisclaimerViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic,retain) IBOutlet UIButton *btnIAgree;
@property (nonatomic,retain) IBOutlet UIScrollView *scroll;
@property (nonatomic,retain) IBOutlet UIImageView *imgBackGround;

-(IBAction)btnIAgree_click:(id)sender;

@end
