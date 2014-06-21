//
//  LoginVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 05/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginVC : UIViewController <UITextFieldDelegate,UIScrollViewDelegate, PPRevealSideViewControllerDelegate>
{
     UITextField *activeTextField;
}

@property (nonatomic,retain) IBOutlet UIButton *btnHomePage;
@property (nonatomic,retain) IBOutlet UIButton *btnFacebook;
@property (nonatomic,retain) IBOutlet UIButton *btnLogin;
@property (nonatomic,retain) IBOutlet UIButton *btnRegister;
@property (nonatomic,retain) IBOutlet UIView *viewButtons;
@property (nonatomic,retain) IBOutlet UIView *viewLogin;
@property (nonatomic,retain) IBOutlet UITextField *txtEmail;
@property (nonatomic,retain) IBOutlet UITextField *txtPin1;
@property (nonatomic,retain) IBOutlet UITextField *txtpin2,*txtpin3,*txtPint4;
@property (nonatomic,retain) IBOutlet UILabel *lblPin;
@property (nonatomic,retain) IBOutlet UIButton *btnLogin1;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollview;
@property (nonatomic,retain) IBOutlet UITextField *txtEmailIDForForgot;
@property (nonatomic,retain) IBOutlet UIButton *btnSubmit;
@property (nonatomic,retain) IBOutlet UIButton *btnCancel;
@property (nonatomic,retain) IBOutlet UIView *viewForgotPin;
@property (nonatomic,retain) IBOutlet UILabel *lblQuestion;
@property (nonatomic,retain) IBOutlet UITextField *txtAnswer;
@property (nonatomic,retain) IBOutlet UIButton *btnForgotPinSubmit;
@property (nonatomic,retain) IBOutlet UIButton *btnForgotPinCancel;
@property (nonatomic,retain) IBOutlet UIView *viewForgotQuestion;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic,retain) IBOutlet UIImageView *imgBackGround;
@property (nonatomic,retain) IBOutlet UIImageView *imgvehicals;
@property (nonatomic,retain) IBOutlet UIImageView *imgView,*imgView1,*imgView2,*imgView3;
@property (nonatomic,retain) IBOutlet UIButton *btnSkiptoHome;
@property (nonatomic,retain) IBOutlet UIButton *btnCancel1;
@property (nonatomic,retain) IBOutlet UIButton *btnForgotPin;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)loginButtonTouchHandler:(id)sender;

-(IBAction)btnbtnHomepage_click:(id)sender;

-(IBAction)btnbtnLogin_click:(id)sender;
-(IBAction)btnbtnRegister_click:(id)sender;
-(IBAction)btnLogin_click:(id)sender;
-(IBAction)btnCancel_click:(id)sender;
-(IBAction)btnForgetPin_click:(id)sender;
-(IBAction)btnForgotSbmit_click:(id)sender;
-(IBAction)btnForgotCancel11_click:(id)sender;

-(IBAction)btnForgotCancel_click:(id)sender;
-(IBAction)btnForgotPinSubmit_click:(id)sender;
-(IBAction)btnForgotPinSubmit11_click:(id)sender;

-(IBAction)btnForgotPinCancel_click:(id)sender;
- (IBAction)btnMinimize_Click:(id)sender;
- (IBAction)btnNext_Click:(id)sender;
- (IBAction)btnPreviuse_Click:(id)sender;
@end
