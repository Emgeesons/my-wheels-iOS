//
//  LoginWithFacebookVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 13/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface LoginWithFacebookVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,UIToolbarDelegate>
{
    UITextField *txtOtherQuestion;
     UITextField *activeTextField;
}
@property (nonatomic,retain) IBOutlet UIButton *btnBack,*btnSubmit,*btnSecurityQuestion;
@property (nonatomic,retain) IBOutlet UITextField *txtMobileNo,*txtPin1,*txtPin2,*txtPin3,*txtPin4,*txtSecurityQuestion,*txtAnswer;
@property (nonatomic,retain) IBOutlet UISwitch *switchPin;
@property (nonatomic,retain) IBOutlet UIScrollView *scrollview;

-(IBAction)btnBack_click:(id)sender;
-(IBAction)btnSubmit_click:(id)sender;
-(IBAction)btnSecurityQuestion_click:(id)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic,retain) IBOutlet UIView *viewSecurityQuestion;
@property (nonatomic,retain) IBOutlet UITableView *tblSecurityQuestion;
@property (nonatomic,retain) NSMutableArray *arrSecurityQuestion;
@property (nonatomic,retain) IBOutlet UIView *mainView;

- (IBAction) toggleOnForSwitch: (id) sender;

@end
