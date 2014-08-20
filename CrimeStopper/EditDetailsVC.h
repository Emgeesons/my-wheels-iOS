//
//  EditDetailsVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 27/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditDetailsVC : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIToolbarDelegate>
{
    NSDateFormatter *dateFormatter;
    UITextField *activeTextField;
    UIActionSheet *sheet;
    UIDatePicker *timePicker;
}
@property (nonatomic,retain) IBOutlet UIDatePicker *pickerDateOfBirth;
@property (nonatomic,retain) IBOutlet UIView *viewPickerview;
@property (nonatomic,retain) IBOutlet UITextField *txtFname;
@property (nonatomic,retain) IBOutlet UITextField *txtLname;
@property (nonatomic,retain) IBOutlet UITextField *txtEmail;
@property (nonatomic,retain) IBOutlet UITextField *txtDob;
@property (nonatomic,retain) IBOutlet UITextField *txtMobileNo;
@property (nonatomic,retain) IBOutlet UITextField *txtpin1;
@property (nonatomic,retain) IBOutlet UITextField *txtpin2;
@property (nonatomic,retain) IBOutlet UITextField *txtpin3;
@property (nonatomic,retain) IBOutlet UITextField *txtpin4;
@property (nonatomic,retain) IBOutlet UITextField *txtquestion;
@property (nonatomic,retain) IBOutlet UITextField *txtAnswer;
@property (nonatomic,retain) IBOutlet UITextField *txtLicenceNo;
@property (nonatomic,retain) IBOutlet UITextField *txtStreet;
@property (nonatomic,retain) IBOutlet UITextField *txtPostCode,*txtSecurityQuestion;                                                                                                                                                                                                                                                                                                                                                                                                                                    
@property (nonatomic,retain) IBOutlet UISegmentedControl *gender;
@property (nonatomic,retain) IBOutlet UISwitch *switchbtn;
@property (nonatomic,retain) IBOutlet UIScrollView *scroll;
@property (nonatomic,retain) IBOutlet UIView *viewSecurityQuestion;
@property (nonatomic,retain) IBOutlet UITableView *tblSecurityQuestion;
@property (nonatomic,retain) NSMutableArray *arrSecurityQuestion;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic,retain) IBOutlet UIButton *btnSecurityQuestion;

-(IBAction)btnSecurityQuestion_click:(id)sender;
- (IBAction)btnMinimize_Click:(id)sender;
- (IBAction)btnNext_Click:(id)sender;
- (IBAction)btnPreviuse_Click:(id)sender;

-(IBAction)btnBack_click:(id)sender;
-(IBAction)btnSave_clicl:(id)sender;
- (IBAction) toggleOnForSwitch:(id) sender;
@end
