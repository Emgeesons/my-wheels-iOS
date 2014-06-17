//
//  RegistrationVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 07/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationVC : UIViewController <UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIToolbarDelegate>
{
     NSDateFormatter *dateFormatter;
     UITextField *activeTextField;
    UIActionSheet *sheet;
    UIDatePicker *timePicker;
}

@property (nonatomic,retain) IBOutlet UIView *viewPickerview;
@property (nonatomic,retain) IBOutlet UITextField *txtFname;
@property (nonatomic,retain) IBOutlet UITextField *txtLname;
@property (nonatomic,retain) IBOutlet UITextField *txtEmailAddress;
@property (nonatomic,retain) IBOutlet UITextField *txtMobileNo;
@property (nonatomic,retain) IBOutlet UITextField *txtPin1;
@property (nonatomic,retain) IBOutlet UITextField *txtPin2;
@property (nonatomic,retain) IBOutlet UITextField *txtPin3;
@property (nonatomic,retain) IBOutlet UITextField *txtPin4;
@property (nonatomic,retain) IBOutlet UITextField *txtAnswer;
@property (nonatomic,retain) IBOutlet UITextField *txtDateOfBirth;
@property (nonatomic,retain) IBOutlet UIButton *btnSubmit;
@property (nonatomic,retain) IBOutlet UIButton *btndateofbirth;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UIButton *btnSecurityQuestion;
@property (nonatomic,retain) IBOutlet UIButton *btnSecurityCancel;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic,retain) IBOutlet UISegmentedControl *gender;

@property (nonatomic,retain) IBOutlet UIScrollView *scrollview;

@property (nonatomic,retain) IBOutlet UIDatePicker *pickerDateOfBirth;

@property (nonatomic,retain) IBOutlet UISwitch *switchbtn;

@property (nonatomic,retain) IBOutlet UIView *viewSecurityQuestion;
@property (nonatomic,retain) IBOutlet UITableView *tblSecurityQuestion;
@property (nonatomic,retain) NSMutableArray *arrSecurityQuestion;


-(IBAction)btnBack_click:(id)sender;
-(IBAction)btnSubmit_click:(id)sender;
-(IBAction)btnDob_click:(id)sender;
-(IBAction)btnSecurityQuestion_click:(id)sender;


- (IBAction) toggleOnForSwitch: (id) sender;
-(IBAction)changeSeg;

@end
