//
//  LoginVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 05/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController <UITextFieldDelegate,UIScrollViewDelegate>

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

-(IBAction)btnbtnHomepage_click:(id)sender;
-(IBAction)btnbtnFacebook_click:(id)sender;
-(IBAction)btnbtnLogin_click:(id)sender;
-(IBAction)btnbtnRegister_click:(id)sender;
-(IBAction)btnLogin_click:(id)sender;
-(IBAction)btnCancel_click:(id)sender;
-(IBAction)btnForgetPin_click:(id)sender;
@end
