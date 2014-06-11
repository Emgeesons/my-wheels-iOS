//
//  DisclaimerViewController.h
//  CrimeStopper
//
//  Created by Asha Sharma on 05/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginVC.h"

@interface DisclaimerViewController : UIViewController

@property (nonatomic,retain) IBOutlet UIButton *btnIAgree;

-(IBAction)btnIAgree_click:(id)sender;

@end
