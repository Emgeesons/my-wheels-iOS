//
//  EditDetailsVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 27/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "EditDetailsVC.h"
#import "UserProfileVC.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"

@interface EditDetailsVC ()
{
    AppDelegate *appDelegate;
}
@end

@implementation EditDetailsVC
@synthesize arrSecurityQuestion;
NSString *strGender;
int intques;
NSString *strQues;
NSString *strBirthDate;
UITextField *txtOtherQuestion;

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *Fname = [[NSUserDefaults standardUserDefaults] objectForKey:@"first_name"];
    NSString *Lname = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_name"];
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    NSString *dob = [[NSUserDefaults standardUserDefaults] objectForKey:@"dob"];
    NSString *Mobileno = [[NSUserDefaults standardUserDefaults] objectForKey:@"mobile_number"];
    NSString *gender = [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    NSString *strquestion = [[NSUserDefaults standardUserDefaults] objectForKey:@"security_question"];
    NSString *strAnswer = [[NSUserDefaults standardUserDefaults] objectForKey:@"security_answer"];
    NSString *strLicenceNo = [[NSUserDefaults standardUserDefaults] objectForKey:@"license_no"];
    NSString *strstreet = [[NSUserDefaults standardUserDefaults] objectForKey:@"street"];
    NSString *strPostcode = [[NSUserDefaults standardUserDefaults] objectForKey:@"postcode"];
    NSString *strPin1 = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin1"];
    NSString *strPin2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin2"];
    NSString *strPin3 = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin3"];
    NSString *strPin4 = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin4"];
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
   
    
    NSLog(@"dob : %@",dob);
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *datedob = [dateFormatter dateFromString:dob];
    
    NSLog(@"dob : %@",datedob);
    
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *date = [dateFormatter stringFromDate:datedob];
    
   
    NSLog(@"dob1 : %@",date );

    _txtDob.text = date;
    if ([timePicker.date compare:timePicker.date] == NSOrderedDescending)
    {
        NSTimeInterval minutesToStartTime = [timePicker.date timeIntervalSinceDate:timePicker.date] / 60;
        NSLog(@"Start time is in %02d+%02d", (int)(minutesToStartTime / 60), (int)minutesToStartTime % 60);
        
        //[pickerDateOfBirth setHidden:YES];
        
        return;
    }
    else
    {
        
    }

    NSLog(@"strquestion : %@",strquestion);
    if([gender isEqualToString:@"male"])
    {
        [self.gender setImage:[[UIImage imageNamed:@"male_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [self.gender setImage:[[UIImage imageNamed:@"female_inactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
        strGender = @"male";
       
	}
	else
    {
        [self.gender setImage:[[UIImage imageNamed:@"male_inactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [self.gender setImage:[[UIImage imageNamed:@"female_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
        strGender = @"female";
       
    }

    
    _txtFname.text = Fname;
    _txtLname.text = Lname;
    _txtEmail.text = email;
   
    _txtMobileNo.text = Mobileno;
    [_btnSecurityQuestion setTitle:strquestion forState:UIControlStateNormal];
    _txtAnswer.text = strAnswer;
    _txtLicenceNo.text = strLicenceNo;
    _txtStreet.text = strstreet;
    _txtPostCode.text = strPostcode;
    _txtpin1.text = strPin1;
    _txtpin2.text = strPin2;
    _txtpin3.text = strPin3;
    _txtpin4.text = strPin4;
    
    
    arrSecurityQuestion = [[NSMutableArray alloc]init];
    [arrSecurityQuestion addObject:@"Security Questions"];
    [arrSecurityQuestion addObject:@"Passport Number"];
    [arrSecurityQuestion addObject:@"Licence Number"];
    [arrSecurityQuestion addObject:@"Mother's maiden name"];
    [arrSecurityQuestion addObject:@"First pet's name"];
    [arrSecurityQuestion addObject:@"First childhood friend"];
    [arrSecurityQuestion addObject:@"First primary school"];
    [arrSecurityQuestion addObject:@"Colour of your first car"];
    [arrSecurityQuestion addObject:@"All time favourite movie"];
    [arrSecurityQuestion addObject:@"First paid job"];
    [arrSecurityQuestion addObject:@"Other"];
    [_viewSecurityQuestion setHidden:YES];
    
    
    [self.txtAnswer setDelegate:self];
    [self.txtDob setDelegate:self];
    [self.txtEmail setDelegate:self];
    [self.txtFname setDelegate:self];
    [self.txtLname setDelegate:self];
    [self.txtMobileNo setDelegate:self];
    [self.txtpin1 setDelegate:self];
    [self.txtpin2 setDelegate:self];
    [self.txtpin3 setDelegate:self];
    [self.txtpin4 setDelegate:self];
    [_txtLicenceNo setDelegate:self];
    
    
     self.txtDob.inputView = self.pickerDateOfBirth;
    [_toolbar setFrame:CGRectMake(0, -30, 320, 40)];
    [_txtDob setInputAccessoryView:self.toolbar];
    
    [_txtAnswer setInputAccessoryView:self.toolbar];
    [_txtEmail setInputAccessoryView:self.toolbar];
    [_txtFname setInputAccessoryView:self.toolbar];
    [_txtLname setInputAccessoryView:self.toolbar];
    [_txtMobileNo setInputAccessoryView:self.toolbar];
    [_txtquestion setInputAccessoryView:self.toolbar];
    [_txtpin1 setInputAccessoryView:self.toolbar];
    [_txtpin2 setInputAccessoryView:self.toolbar];
    [_txtpin3 setInputAccessoryView:self.toolbar];
    [_txtpin4 setInputAccessoryView:self.toolbar];
    [_txtLicenceNo setInputAccessoryView:self.toolbar];
    [_txtStreet setInputAccessoryView:self.toolbar];
    [_txtPostCode setInputAccessoryView:self.toolbar];
    
    if(IsIphone5)
    {
        _scroll.frame = CGRectMake(0 , 58, 320, 568+50);
        _scroll.contentSize = CGSizeMake(320, 700);
    }
    else
    {
        _scroll.frame = CGRectMake(0 , 58, 320, 568+50);
        
        _scroll.contentSize = CGSizeMake(320, 700);
    }

    [self.view addSubview:_viewPickerview];
    [self.viewPickerview addSubview:_pickerDateOfBirth];
    [_viewPickerview setHidden:YES];
    //[txtOtherQuestion setInputAccessoryView:self.toolbar];
    
    
   //  [txtAnswer setFrame:CGRectMake(5, 338, 300, 30)];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}
- (IBAction) toggleOnForSwitch:(id) sender
{
    if (_switchbtn.on)
    {
        _txtpin1.secureTextEntry = NO;
        _txtpin2.secureTextEntry = NO;
        _txtpin3.secureTextEntry = NO;
        _txtpin4.secureTextEntry = NO;
        NSLog(@"switch is off");
        _switchbtn.on = YES;
    }
    else
    {
        NSLog(@"switch is on..");
        _txtpin1.secureTextEntry = YES;
        _txtpin2.secureTextEntry = YES;
        _txtpin3.secureTextEntry = YES;
        _txtpin4.secureTextEntry = YES;
        
        _switchbtn.on = NO;
        
    }
}
#pragma mark button click event
-(IBAction)btnBack_click:(id)sender
{
    UserProfileVC *vc = [[UserProfileVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)changeSeg
{
    if(_gender.selectedSegmentIndex == 0)
    {
        [self.gender setImage:[[UIImage imageNamed:@"male_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [self.gender setImage:[[UIImage imageNamed:@"female_inactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
        strGender = @"male";
	}
	else
    {
        [self.gender setImage:[[UIImage imageNamed:@"male_inactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
        [self.gender setImage:[[UIImage imageNamed:@"female_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
        strGender = @"female";
    }
}
-(IBAction)btnSave_clicl:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"Please connect to the internet to continue."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
    } else {
        NSLog(@"There IS internet connection");
    
    
    
    if (_txtFname.text.length==0 || _txtLname.text.length==0 || _txtEmail.text.length==0 || _txtMobileNo.text.length==0 || _txtDob.text.length==0 || _txtpin1.text.length==0 || _txtpin2.text.length==0 || _txtpin3.text.length==0 || _txtpin4.text.length == 0 || _txtAnswer.text.length == 0 || _txtLicenceNo.text.length == 0 | _txtStreet.text.length == 0 || _txtPostCode.text.length == 0)
    {
        if (_txtFname.text.length == 0)
        {
            [_txtFname setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        if (_txtLname.text.length == 0)
        {
            [_txtLname setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        if (_txtMobileNo.text.length == 0)
        {
            [_txtMobileNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        if (_txtAnswer.text.length == 0)
        {
            [_txtAnswer setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        if(_txtEmail.text.length == 0)
        {
            [_txtEmail setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        if (_txtDob.text.length == 0)
        {
            [_txtDob setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        if (_txtPostCode.text.length == 0)
        {
            [_txtPostCode setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        if(_txtLicenceNo.text.length == 0)
        {
            [_txtLicenceNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        if(_txtPostCode.text.length == 0)
        {
            [_txtPostCode setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        if(_txtStreet.text.length == 0)
        {
            [_txtStreet setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];

        }
        
        
    }
   else if (_txtFname.text.length <2)
    {
        [_txtFname setTextColor:[UIColor redColor]];
    }
  else if (_txtLname.text.length <2)
    {
        [_txtLname setTextColor:[UIColor redColor]];
    }
    else  if ( _txtMobileNo.text.length <2)
    {
        [_txtMobileNo setTextColor:[UIColor redColor]];
    }
   else if ( _txtAnswer.text.length <3)
    {
        [_txtAnswer setTextColor:[UIColor redColor]];
    }
    else if(_txtEmail.text.length == 0)
    {
        [_txtEmail setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    
   
    else if ( _txtPostCode.text.length != 4)
    {
        [_txtPostCode setTextColor:[UIColor redColor]];
    }
     
    else if (_txtLicenceNo.text.length <2)
    {
        [_txtLicenceNo setTextColor:[UIColor redColor]];
    }
    else if (_txtStreet.text.length <2)
    {
            [_txtStreet setTextColor:[UIColor redColor]];
    }
    else
    {
        BOOL isValid = [self NSStringIsValidEmail:_txtEmail.text];
        if (isValid)
        {
            [self submit];
        }
        else
        {
            UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning."
                                                                message:@"Please enter proper Email ID."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            
            [CheckAlert show];
        }
    }
    }

}
-(IBAction)btnSecurityQuestion_click:(id)sender
{
    self.scroll.userInteractionEnabled = NO ;
    [self.view setBackgroundColor:[UIColor grayColor]];
    [_viewSecurityQuestion setHidden:NO];
}
-(IBAction)btnSecurityCancel_click:(id)sender
{
    self.scroll.userInteractionEnabled = YES ;
    
    [self.viewSecurityQuestion setHidden:YES];
    [self.scroll setBackgroundColor:[UIColor whiteColor]];
}
- (IBAction)btnMinimize_Click:(id)sender {
    [activeTextField resignFirstResponder];
}
- (IBAction)btnNext_Click:(id)sender
{
    NSInteger nextTag = activeTextField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [activeTextField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [activeTextField resignFirstResponder];
    }
    
    
}
- (IBAction)btnPreviuse_Click:(id)sender
{
    NSInteger nextTag = activeTextField.tag-1;
    // Try to find next responder
    UIResponder* nextResponder = [activeTextField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [activeTextField resignFirstResponder];
    }
    
    
}
#pragma mark selector method
- (void)DOBChanged:(id)sender
{
    [_viewPickerview setHidden:YES];
    
    NSString *birthDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:timePicker.date]];
   
    NSDate *currentDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:-13]; // note that I'm setting it to -1
    NSDate *maxDate = [gregorian dateByAddingComponents:offsetComponents toDate:currentDate options:0];
    NSLog(@"%@", maxDate);
    
    [offsetComponents setYear:-100]; // note that I'm setting it to -1
    NSDate *minDate = [gregorian dateByAddingComponents:offsetComponents toDate:currentDate options:0];
    NSLog(@"%@", minDate);
    [timePicker setMaximumDate:maxDate];
    [timePicker setMinimumDate:minDate];
    
    NSArray * arr1 = [birthDate componentsSeparatedByString:@"/"];
    NSString *dob;
    dob = [arr1 objectAtIndex:1];
    dob = [dob stringByAppendingString:@"-"];
    dob = [dob stringByAppendingString:[arr1 objectAtIndex:0]];
    dob = [dob stringByAppendingString:@"-"];
    dob = [dob stringByAppendingString:[arr1 objectAtIndex:2]];
    NSLog(@"dob = %@",dob);

    
    _txtDob.text = dob;
    if ([timePicker.date compare:timePicker.date] == NSOrderedDescending)
    {
        NSTimeInterval minutesToStartTime = [timePicker.date timeIntervalSinceDate:timePicker.date] / 60;
        NSLog(@"Start time is in %02d+%02d", (int)(minutesToStartTime / 60), (int)minutesToStartTime % 60);
        
        //[pickerDateOfBirth setHidden:YES];
       
        return;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIDatePicker *datePicker = (UIDatePicker *)sender;
            
            if ([timePicker.date compare:[NSDate date]] == NSOrderedDescending) {
                
                datePicker.date = [NSDate date];
            }
            
        });
    }
    
    NSLog(@"birthdate :%@",birthDate);
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    strBirthDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:timePicker.date]];
    NSLog(@"strdate : %@",strBirthDate);
    self.scroll.userInteractionEnabled = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [timePicker setHidden:YES];
   

    [self cancelClicked];
    
}
-(void)cancelClicked {
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark textfield delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    
    activeTextField=textField;
    NSInteger nextTag = activeTextField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [activeTextField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [activeTextField resignFirstResponder];
    }
    return YES;
}
-(bool)textFieldShouldBeginEditing:(UITextField *)textField
{
   // [pickerDateOfBirth setHidden:YES];
    
    if(textField.tag == 4)
    {
        //[viewPickerview setHidden:NO];
        
        //        self.scrollview.userInteractionEnabled = NO ;
        //        [self.view setBackgroundColor:[UIColor grayColor]];
        
        [_txtEmail resignFirstResponder];
        [_txtFname resignFirstResponder];
        [_txtLname resignFirstResponder];
        [_txtMobileNo resignFirstResponder];
        [_txtquestion resignFirstResponder];
        [_txtAnswer resignFirstResponder];
        [_txtpin1 resignFirstResponder];
        [_txtpin2 resignFirstResponder];
        [_txtpin3 resignFirstResponder];
        [_txtpin4 resignFirstResponder];
        [_pickerDateOfBirth setHidden:NO];
        
        // Open DatePicker when age textfield is clicked
        
        [_viewPickerview setHidden:NO];
        self.scroll.userInteractionEnabled = NO ;
        [self.view setBackgroundColor:[UIColor lightGrayColor]];

        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake ( 0.0, 44.0, 0.0, 0.0)];
        timePicker.backgroundColor = [UIColor whiteColor];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        
        NSDate *currentDate = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        [offsetComponents setYear:-13]; // note that I'm setting it to -1
        NSDate *maxDate = [gregorian dateByAddingComponents:offsetComponents toDate:currentDate options:0];
        NSLog(@"%@", maxDate);
        
        [offsetComponents setYear:-100]; // note that I'm setting it to -1
        NSDate *minDate = [gregorian dateByAddingComponents:offsetComponents toDate:currentDate options:0];
        NSLog(@"%@", minDate);
        [timePicker setMaximumDate:maxDate];
        [timePicker setMinimumDate:minDate];
        
        
        //format datePicker mode. in this example time is used
        timePicker.datePickerMode = UIDatePickerModeDate;
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        UIView *toolbarPicker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolbarPicker.backgroundColor = [UIColor grayColor];
        [toolbarPicker sizeToFit];
        
        UIButton *bbitem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [bbitem setTitle:@"Done" forState:UIControlStateNormal];
        [bbitem addTarget:self action:@selector(DOBChanged:) forControlEvents:UIControlEventTouchUpInside];
        //
        //        UIButton *bbitem1 = [[UIButton alloc] initWithFrame:CGRectMake(250, 0, 60, 44)];
        //        [bbitem1 setTitle:@"Cancel" forState:UIControlStateNormal];
        //        //[bbitem1 setTitleColor:[UIColor colorWithHexString:@"#FE2E2E"] forState:UIControlStateNormal];
        //        [bbitem1 addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        //
        [toolbarPicker addSubview:bbitem];
        //        [toolbarPicker addSubview:bbitem1];
        [sheet addSubview:toolbarPicker];
        [sheet addSubview:toolbarPicker];
        [sheet addSubview:timePicker];
        [sheet showInView:self.view];
        [sheet setBounds:CGRectMake(0,0,320, 464)];
        return NO;

    }
    //    activeTextField=textField;
    if(textField == _txtEmail)
    {
        [_txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
        [_txtEmail reloadInputViews];
    }
    else if (textField == _txtMobileNo)
    {
        [_txtMobileNo setKeyboardType:UIKeyboardTypeDecimalPad];
        [_txtMobileNo reloadInputViews];
    }
    else if(textField == _txtDob)
    {
        [self.txtDob endEditing:YES];
        [self.txtDob resignFirstResponder];
       // [pickerDateOfBirth setHidden:NO];
      //  [btnSubmit setHidden:YES];
    }
    else if(textField == _txtDob)
    {
      //  [viewPickerview setHidden:NO];
        self.scroll.userInteractionEnabled = NO ;
        [self.view setBackgroundColor:[UIColor grayColor]];
        
        if(IsIphone5)
        {
            [self.txtDob endEditing:YES];
            [self.txtDob resignFirstResponder];
            
            
//            [pickerDateOfBirth setHidden:NO];
//            [btnSubmit setHidden:YES];
        }
        else
        {
            [self.txtDob endEditing:YES];
            [self.txtDob resignFirstResponder];
            
//            pickerDateOfBirth.frame = CGRectMake(0, 270, 320, pickerDateOfBirth.frame.size.height);
//            
//            [pickerDateOfBirth setHidden:NO];
//            [btnSubmit setHidden:YES];
        }
    }
    else if (textField.tag == 6 || textField.tag == 7 || textField.tag == 8 || textField.tag == 9)
    {
        [_txtMobileNo setKeyboardType:UIKeyboardTypeDecimalPad];
        [_txtMobileNo reloadInputViews];
    }
    else
    {
        [_txtFname setKeyboardType:UIKeyboardTypeDefault];
        [_txtFname reloadInputViews];
    }
    int y=0;
    // txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,380,300,30)];
    if(textField == _txtquestion)
    {
        y=50;
        // txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,300,300,30)];
    }
    if(textField == _txtAnswer)
    {
        y=80;
        //[btnSubmit setHidden:NO];
    }
    NSLog(@"y = %d",y);
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:_scroll];
        rc.origin.x = 0 ;
        rc.origin.y = y ;
        CGPoint pt=rc.origin;
        [self.scroll setContentOffset:pt animated:YES];
    }completion:nil];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
     [textField setTextColor:[UIColor blackColor]];
    //pickerDateOfBirth setHidden:YES];
     activeTextField = textField ;
    int y=0;
    if(textField.tag == 4)
    {
        
        [_txtEmail resignFirstResponder];
        [_txtFname resignFirstResponder];
        [_txtLname resignFirstResponder];
        [_txtMobileNo resignFirstResponder];
        [_txtquestion resignFirstResponder];
        [_txtAnswer resignFirstResponder];
        [_txtpin1 resignFirstResponder];
        [_txtpin2 resignFirstResponder];
        [_txtpin3 resignFirstResponder];
        [_txtpin4 resignFirstResponder];
        [_pickerDateOfBirth setHidden:NO];
        
        
        
        
        
        
        
    }
    if(textField == _txtEmail)
    {
        [_txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
        [_txtEmail reloadInputViews];
    }
    else if (textField == _txtMobileNo)
    {
        [_txtMobileNo setKeyboardType:UIKeyboardTypeDecimalPad];
        [_txtMobileNo reloadInputViews];
       // [btnSubmit setHidden:NO];
    }
//    else if(textField == _txtDob)
//    {
//        [viewPickerview setHidden:NO];
//        self.scrollview.userInteractionEnabled = NO ;
//        [self.view setBackgroundColor:[UIColor grayColor]];
//        if(IsIphone5)
//        {
//            [self.txtDateOfBirth endEditing:YES];
//            [self.txtDateOfBirth resignFirstResponder];
//            
//            [pickerDateOfBirth setHidden:NO];
//            [btnSubmit setHidden:YES];
//        }
//        else
//        {
//            [self.txtDateOfBirth endEditing:YES];
//            [self.txtDateOfBirth resignFirstResponder];
//            pickerDateOfBirth.frame = CGRectMake(0, 270, 320, pickerDateOfBirth.frame.size.height);
//            
//            [pickerDateOfBirth setHidden:NO];
//            [btnSubmit setHidden:YES];
//        }
//    }
    
    
    else if (textField.tag == 6 || textField.tag == 7 || textField.tag == 8 || textField.tag == 9)
    {
        [_txtMobileNo setKeyboardType:UIKeyboardTypeDecimalPad];
        [_txtMobileNo reloadInputViews];
        y=50;
    }
    else
    {
        [_txtFname setKeyboardType:UIKeyboardTypeDefault];
        [_txtFname reloadInputViews];
    }
    // txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,380,300,30)];
    if(textField == _txtquestion)
    {
        y=210;
        [_txtquestion setInputAccessoryView:self.toolbar];
        // txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,300,300,30)];
    }
    if(textField == _txtAnswer)
    {
        y=210;
       // [btnSubmit setHidden:NO];
    }
    if(textField == _txtLicenceNo)
    {
        y=210;
        // [btnSubmit setHidden:NO];
    }
    if(textField == _txtStreet)
    {
        y=210;
        // [btnSubmit setHidden:NO];
    }
    if(textField == _txtPostCode)
    {
        y=210;
        // [btnSubmit setHidden:NO];
    }
    
    NSLog(@"y = %d",y);
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:_scroll];
        rc.origin.x = 0 ;
        rc.origin.y = y ;
        CGPoint pt=rc.origin;
        [self.scroll setContentOffset:pt animated:YES];
    }completion:nil];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _txtDob)
    {
        if([_txtDob.text isEqualToString:@""])
        {
            
        }
        else
        {
            //[pickerDateOfBirth setHidden:YES];
        }
    }
    
    int y=0;
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:_scroll];
        rc.origin.x = 0 ;
        rc.origin.y = y-20 ;
        CGPoint pt=rc.origin;
        [self.scroll setContentOffset:pt animated:YES];
    }completion:nil];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == _txtDob)
    {
    }
    if(textField.tag == 6)
    {
        NSUInteger newLength = [_txtpin1.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            // return NO;
            [_txtpin1 resignFirstResponder];
            [_txtpin2 becomeFirstResponder];
        }
        else if (newLength == 0)
        {
            _txtpin1.text = @"";
        }
        else
        {
            NSLog(@"YES");
            
            return YES;
            [_txtpin1 resignFirstResponder];
            [_txtpin2 becomeFirstResponder];
        }
        
        // return (newLength > 1) ? NO : YES;
    }
    else if (textField.tag == 7)
    {
        NSUInteger newLength = [_txtpin2.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [_txtpin2 resignFirstResponder];
            [_txtpin3 becomeFirstResponder];
        }
        if(newLength == 0)
        {
            [_txtpin2 resignFirstResponder];
            [_txtpin1 becomeFirstResponder];
            _txtpin2.text = @"";
        }
        else
        {
            [_txtpin2 resignFirstResponder];
            [_txtpin3 becomeFirstResponder];
        }
        
    }
    else if(textField.tag == 8)
    {
        NSUInteger newLength = [_txtpin3.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [_txtpin3 resignFirstResponder];
            [_txtpin4 becomeFirstResponder];
            //return NO;
        }
        if(newLength == 0)
        {
            [_txtpin3 resignFirstResponder];
            [_txtpin2 becomeFirstResponder];
            _txtpin3.text = @"";
        }
        else
        {
            [_txtpin3 resignFirstResponder];
            [_txtpin4 becomeFirstResponder];
        }
        
        
    }
    else if (textField.tag == 8)
    {
        NSUInteger newLength = [_txtpin4.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            //return NO;
        }
        else if(newLength == 0)
        {
            _txtpin4.text = @"";
            [_txtpin4 resignFirstResponder];
            [_txtpin4 becomeFirstResponder];
            
        }
        else
        {
            [_txtpin4 resignFirstResponder];
        }
    }
    //    else if (textField == txtFname)
    //    {
    //        NSUInteger newLength = [txtFname.text length] + [string length] - range.length;
    //        return (newLength > 2) ? YES  : NO;
    //    }
    //    else if (textField == txtLname)
    //    {
    //        NSUInteger newLength = [txtLname.text length] + [string length] - range.length;
    //        return (newLength > 2) ? YES  : NO;
    //    }
    //    else if (textField == txtMobileNo)
    //    {
    //        NSUInteger newLength = [txtMobileNo.text length] + [string length] - range.length;
    //        return (newLength > 5) ? YES  : NO;
    //    }
    else
    {
        
    }
    return 1;
}
#pragma mark call api and chack validation
-(BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
-(void)submit
{
    NSLog(@"valid email...");
    NSString *strPin;
    strPin = @"";
    strPin = [strPin stringByAppendingString:_txtpin1.text];
    strPin = [strPin stringByAppendingString:_txtpin2.text];
    strPin = [strPin stringByAppendingString:_txtpin3.text];
    strPin = [strPin stringByAppendingString:_txtpin4.text];
    NSLog(@"strpin :: %@",strPin);
    NSString *strQuestion;
    strQuestion = @"What is your ";
//    if(intques == 2)
//    {
//        strQuestion = [strQuestion stringByAppendingString:strQues];
//        NSLog(@"ques :: %@",strQues);
//    }
//    else if (intques == 1)
//    {
//        strQuestion = txtOtherQuestion.text;
//    }
//    else
//    {
//        
//    }
    
    /*
     --userId
    -- firstName
     --lastName
    -- email
    -- dob
    -- gender
    -- mobileNumber
  --   pin
    -- latitude
   --  longitude
    -- oldPin ( can be taken from persistent storage)
    -- securityQuestion
    -- securityAnswer
     licenceNo
     address
     pincode
     os
     make
     model

     */
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"oldPin"];
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
  //  NSString *strQue;
    
    if(intques == 2)
    {
        strQuestion = @"What is your ";
        strQuestion = [strQuestion stringByAppendingString:strQues];
        NSLog(@"ques :: %@",strQuestion);
    }
    else if (intques == 1)
    {
        strQuestion = _txtquestion.text;
    }
    else
    {
        strQuestion =  _btnSecurityQuestion.currentTitle;
    }


    // WebApiController *obj=[[WebApiController alloc]init];
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:UserID forKey:@"userId"];
    [param setValue:_txtEmail.text forKey:@"email"];
    [param setValue:strPin forKey:@"pin"];
    [param setValue:_txtFname.text forKey:@"firstName"];
    [param setValue:_txtLname.text forKey:@"lastName"];
    [param setValue:_txtMobileNo.text forKey:@"mobileNumber"];
    NSLog(@"strbirthdate : %@",strBirthDate);
    // [param setValue:[dateFormatter stringFromDate:pickerDateOfBirth.date] forKey:@"dob"];
    if(strBirthDate == nil || strBirthDate == (id)[NSNull null] || [strBirthDate isEqualToString:@""])
    {
         NSString *dob = [[NSUserDefaults standardUserDefaults] objectForKey:@"dob"];
         [param setValue:dob forKey:@"dob"];
    }
    else
    {
        NSLog(@"strbirthdate : %@",strBirthDate);
       [param setValue:strBirthDate forKey:@"dob"];
    }
    [param setValue:strGender forKey:@"gender"];
    [param setValue:strQuestion forKey:@"securityQuestion"];
    [param setValue:_txtAnswer.text  forKey:@"securityAnswer"];
    [param setValue:latitude forKey:@"latitude"];
    [param setValue:longitude forKey:@"longitude"];
    [param setValue:pin forKey:@"oldPin"];
    [param setValue:_txtLicenceNo.text forKey:@"licenceNo"];
    [param setValue:_txtStreet.text forKey:@"address"];
    [param setValue:_txtPostCode.text forKey:@"pincode"];
    [param setValue:@"ios7" forKey:@"os"];
    [param setValue:@"iPhone" forKey:@"make"];
    [param setValue:@"iPhone5,iPhone5s" forKey:@"model"];
    
    NSLog(@"param : %@",param);
    // [obj callAPI_POST:@"register.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
      NSString *url = [NSString stringWithFormat:@"%@updateProfile.php", SERVERNAME];
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"url : %@",manager);
    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              
              NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
              
              NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
              NSLog(@"data : %@",jsonDictionary);
              //  NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
              
              //  NSMutableArray *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
              NSLog(@"Json dictionary :: %@",jsonDictionary);
              NSString *EntityID = [jsonDictionary valueForKey:@"status"];
              NSLog(@"message %@",EntityID);
              if ([EntityID isEqualToString:@"success"])
              {
                  [[NSUserDefaults standardUserDefaults] setValue:UserID forKey:@"UserID"];
                  if(strBirthDate == nil || strBirthDate == (id)[NSNull null] || [strBirthDate isEqualToString:@""])
                  {
                      NSString *dob = [[NSUserDefaults standardUserDefaults] objectForKey:@"dob"];
                      [[NSUserDefaults standardUserDefaults] setValue:dob forKey:@"dob"];
                  }
                  else
                  {
                      [[NSUserDefaults standardUserDefaults] setValue:strBirthDate forKey:@"dob"];
                  }
                  
                  [[NSUserDefaults standardUserDefaults] setValue:_txtEmail.text forKey:@"email"];
                  //  [[NSUserDefaults standardUserDefaults] setValue:emergencyContact forKey:@"emergencyContact"];
                  // [[NSUserDefaults standardUserDefaults] setValue:emergency_contact_number forKey:@"emergency_contact_number"];
                  //  [[NSUserDefaults standardUserDefaults] setValue:fb_id forKey:@"fb_id"];
                  //  [[NSUserDefaults standardUserDefaults] setValue:fb_token forKey:@"fb_token"];
                  [[NSUserDefaults standardUserDefaults] setValue:_txtFname.text forKey:@"first_name"];
                  [[NSUserDefaults standardUserDefaults] setValue:strGender forKey:@"gender"];
                  [[NSUserDefaults standardUserDefaults] setValue:_txtLname.text forKey:@"last_name"];
                  [[NSUserDefaults standardUserDefaults] setValue:_txtLicenceNo.text forKey:@"license_no"];
                  // [[NSUserDefaults standardUserDefaults] setValue:license_photo_url forKey:@"license_photo_url"];
                  [[NSUserDefaults standardUserDefaults] setValue:_txtMobileNo.text forKey:@"mobile_number"];
                  //[[NSUserDefaults standardUserDefaults] setValue:modified_at forKey:@"modified_at"];
                  // [[NSUserDefaults standardUserDefaults] setValue:photo_url forKey:@"photo_url"];
                  [[NSUserDefaults standardUserDefaults] setValue:_txtPostCode.text forKey:@"postcode"];
                  //street
                  [[NSUserDefaults standardUserDefaults] setValue:_txtStreet.text forKey:@"street"];
                  //[[NSUserDefaults standardUserDefaults] setValue:samaritan_points forKey:@"samaritan_points"];
                  [[NSUserDefaults standardUserDefaults] setValue:_txtAnswer.text forKey:@"security_answer"];
                  [[NSUserDefaults standardUserDefaults] setValue:strQuestion forKey:@"security_question"];
                  [[NSUserDefaults standardUserDefaults] setValue:_txtStreet.text forKey:@"street"];
                  
                  UserProfileVC *vc = [[UserProfileVC alloc]init];
                  [self.navigationController pushViewController:vc animated:YES];
              }
              else
              {
                  NSString *strmessage = [jsonDictionary valueForKey:@"message"];
                  UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                                      message:strmessage
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil, nil];
                  [CheckAlert show];
              }
              [SVProgressHUD dismiss];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@ ***** %@", operation.responseString, error);
          }];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
}

#pragma mark table view methods for securyity question
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSecurityQuestion count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    
    
    
    if(indexPath.row == 0)
    {
        [cell.textLabel setText:[arrSecurityQuestion objectAtIndex:0]];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        [cell.textLabel setTextColor:[UIColor blackColor]];
        
    }
    
    else
    {
        [cell.textLabel setText:[arrSecurityQuestion objectAtIndex:indexPath.row]];
        [cell.textLabel setTextColor:[UIColor blueColor]];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        // [cell.textLabel setValue:[UIColor blueColor] forKeyPath:[arrSecurityQuestion objectAtIndex:indexPath.row]];
    }
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.scroll.userInteractionEnabled = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if(indexPath.row == 10)
    {
        intques = 1;
        [txtOtherQuestion setHidden:NO];
        _txtAnswer.text = @"";
        // [self.scrollview removeFromSuperview];
        [_btnSecurityQuestion setTitle:[arrSecurityQuestion objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [_btnSecurityQuestion setEnabled:YES];
        [_btnSecurityQuestion setFrame:CGRectMake(5, 275, 300, 30)  ];
        txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,315,300,30)];
        [_txtAnswer setFrame:CGRectMake(5, 350, 300, 30)];
        [_txtLicenceNo setFrame:CGRectMake(5, 390, 300, 30)];
        [_txtStreet setFrame:CGRectMake(5, 430, 300, 30)];
        [_txtPostCode setFrame:CGRectMake(5, 470, 300, 30)];
        // [self.scrollview addSubview:txtAnswer];
        txtOtherQuestion.borderStyle = UITextBorderStyleRoundedRect;
        txtOtherQuestion.font = [UIFont systemFontOfSize:15];
        txtOtherQuestion.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0];
        //  [txtOtherQuestion setBackgroundColor:[UIColor colorWithRed:170 green:170 blue:170 alpha:1]];
        txtOtherQuestion.keyboardType = UIKeyboardTypeDefault;
        txtOtherQuestion.returnKeyType = UIReturnKeyDefault;
        txtOtherQuestion.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtOtherQuestion.placeholder = @"enter question *";
        txtOtherQuestion.tag = 10;
        txtOtherQuestion.delegate = self;
        
        [self.scroll addSubview:txtOtherQuestion];
        [_viewSecurityQuestion setHidden:YES];
        
    }
    
    else
    {
        intques = 2;
        [_txtAnswer setText:@""];
        [txtOtherQuestion setHidden:YES];
        NSLog(@"selected value : %@",[arrSecurityQuestion objectAtIndex:indexPath.row]);
        strQues = [arrSecurityQuestion objectAtIndex:indexPath.row];
        [_btnSecurityQuestion setTitle:[arrSecurityQuestion objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [_btnSecurityQuestion setEnabled:YES];
        [_viewSecurityQuestion setHidden:YES];
        [txtOtherQuestion setHidden:YES];
        [_btnSecurityQuestion setFrame:CGRectMake(5, 275, 300, 30)  ];
        [_txtAnswer setFrame:CGRectMake(5, 315, 300, 30)];
        [_txtLicenceNo setFrame:CGRectMake(5, 355, 300, 30)];
        [_txtStreet setFrame:CGRectMake(5, 395, 300, 30)];
        [_txtPostCode setFrame:CGRectMake(5, 435, 300, 30)];
        
    }
    
}

@end
