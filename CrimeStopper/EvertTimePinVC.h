//
//  EvertTimePinVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 21/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"

@class HomePageVC;
@class LoginVC;

@interface EvertTimePinVC : UIViewController <UITextFieldDelegate,PPRevealSideViewControllerDelegate>
{
    UITextField *activeTextField;
    UIActionSheet *sheet;
}
@property (nonatomic, retain) UINavigationController *nav;

@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
@property (nonatomic,strong) LoginVC *LoginVC;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) IBOutlet UIView *viewPin;
@property (nonatomic,retain) IBOutlet UITextField *txtPin1;
@property (nonatomic,retain) IBOutlet UITextField *txtPin2;
@property (nonatomic,retain) IBOutlet UITextField *txtPin3;
@property (nonatomic,retain) IBOutlet UITextField *txtPin4;
@property (nonatomic,retain) IBOutlet UIButton *btnContinue;
@property (nonatomic,retain) IBOutlet UIButton *btnForgotPin;
@property (nonatomic,retain) IBOutlet UIButton *btnSign;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic,strong) HomePageVC *homePage;

-(IBAction)btnForgotPin_click:(id)sender;
-(IBAction)btnSignInUser_click:(id)sender;
-(IBAction)btnContinue_click:(id)sender;

@end
