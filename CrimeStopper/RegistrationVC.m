//
//  RegistrationVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 07/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "RegistrationVC.h"
#import "LoginVC.h"
#import "WebApiController.h"
#import "SVProgressHUD.h"
#import "HomePageVC.h"

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface RegistrationVC ()
{
    UIActionSheet *actionSheet;
}
@end

@implementation RegistrationVC
@synthesize txtEmailAddress,txtFname,txtLname,txtMobileNo,txtPin1,txtPin2,txtPin3,txtPin4,txtAnswer;
@synthesize btnBack,btndateofbirth,btnSubmit;
@synthesize scrollview;
@synthesize gender;
@synthesize pickerDateOfBirth;
@synthesize txtDateOfBirth;
@synthesize switchbtn;
NSString *strGender;
NSString *strQues;
@synthesize viewSecurityQuestion,tblSecurityQuestion;
@synthesize arrSecurityQuestion;
@synthesize btnSecurityQuestion;
@synthesize btnSecurityCancel;
@synthesize toolbar;
@synthesize viewPickerview;

UITextField *txtOtherQuestion;
int intques;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark main methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [pickerDateOfBirth setHidden:YES];
     [pickerDateOfBirth addTarget:self action:@selector(DOBChanged:) forControlEvents:UIControlEventValueChanged];
    dateFormatter = [[NSDateFormatter alloc] init];
    [self.gender setImage:[[UIImage imageNamed:@"male_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
    [self.gender setImage:[[UIImage imageNamed:@"female_inactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
    strGender = @"male";
    [dateFormatter setDateFormat:@"yyyy-mm-dd"];
    self.navigationController.navigationBarHidden = YES;
    //set value in array
    [self.view addSubview:viewPickerview];
    [self.viewPickerview addSubview:pickerDateOfBirth];
    [viewPickerview setHidden:YES];
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
    [viewSecurityQuestion setHidden:YES];
    
      [txtAnswer setFrame:CGRectMake(5, 300, 300, 30)];
    
        [self.txtAnswer setDelegate:self];
        [self.txtDateOfBirth setDelegate:self];
        [self.txtEmailAddress setDelegate:self];
        [self.txtFname setDelegate:self];
        [self.txtLname setDelegate:self];
    [self.txtMobileNo setDelegate:self];
    [self.txtPin1 setDelegate:self];
    [self.txtPin2 setDelegate:self];
    [self.txtPin3 setDelegate:self];
    [self.txtPin4 setDelegate:self];
    
    
    // self.txtDateOfBirth.inputView = self.pickerDateOfBirth;
    [toolbar setFrame:CGRectMake(0, -30, 320, 40)];
     [txtDateOfBirth setInputAccessoryView:self.toolbar];
  
       [txtAnswer setFrame:CGRectMake(5, 338, 300, 30)];
//    [toolbar setBarStyle:UIBarStyleBlackOpaque];
//    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done"
//                                                                      style:UIBarButtonItemStyleBordered target:self action:@selector(changeDateFromLabel:)];
//    toolbar.items = [[NSArray alloc] initWithObjects:barButtonDone,nil];
//    barButtonDone.tintColor=[UIColor blackColor];
//   // [pickerView addSubview:toolBar];
    
   // self.toolbar.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), CGRectGetWidth(self.toolbar.frame), CGRectGetHeight(self.toolbar.frame));
    [self.pickerDateOfBirth addSubview:toolbar];
    
   

    
}
- (void)setPickerHidden:(BOOL)hidden
{
    CGAffineTransform transform = hidden ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.pickerDateOfBirth.frame));
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pickerDateOfBirth.transform = transform;
    }];
}
-(void)changeDateFromLabel:(id)sender
{
    [self.pickerDateOfBirth resignFirstResponder];
    [pickerDateOfBirth setHidden:YES];
    [toolbar setHidden:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(IsIphone5)
    {
        scrollview.frame = CGRectMake(4 , 58, 320, 568+50);
         self.scrollview.contentSize = CGSizeMake(320, 800);
    }
    else
    {
         scrollview.frame = CGRectMake(4 , 58, 320, 568+50);
        
        self.scrollview.contentSize = CGSizeMake(320, 700);
    }
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark selector method
- (void)DOBChanged:(id)sender
{
    [viewPickerview setHidden:YES];
    
    NSString *birthDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:timePicker.date]];
    NSDate *todayDate = [NSDate date];
   
    
    int time = [todayDate timeIntervalSinceDate:[dateFormatter dateFromString:birthDate]];
    int allDays = (((time/60)/60)/24);
    int days = allDays%365;
    int years = (allDays-days)/365;
    
    NSLog(@"You live since %i years and %i days",years,days);
     txtDateOfBirth.text = [[NSString stringWithFormat:@"%i",years] stringByAppendingString:@" Years"];
    if ([timePicker.date compare:timePicker.date] == NSOrderedDescending)
    {
        NSTimeInterval minutesToStartTime = [timePicker.date timeIntervalSinceDate:timePicker.date] / 60;
        NSLog(@"Start time is in %02d+%02d", (int)(minutesToStartTime / 60), (int)minutesToStartTime % 60);
       
        //[pickerDateOfBirth setHidden:YES];
        [btnSubmit setHidden:YES];
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
   
    self.scrollview.userInteractionEnabled = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
     [timePicker setHidden:YES];
    [btnSubmit setHidden:NO];
     [self cancelClicked];
    
}
-(void)cancelClicked {
    [sheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark segmented method
-(IBAction)changeSeg
{
    if(gender.selectedSegmentIndex == 0)
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

#pragma mark switch button method
- (IBAction) toggleOnForSwitch:(id) sender
{
    if (switchbtn.on)
    {
        txtPin1.secureTextEntry = NO;
        txtPin2.secureTextEntry = NO;
        txtPin3.secureTextEntry = NO;
        txtPin4.secureTextEntry = NO;
        NSLog(@"switch is off");
        switchbtn.on = YES;
    }
    else
    {
        NSLog(@"switch is on..");
        txtPin1.secureTextEntry = YES;
        txtPin2.secureTextEntry = YES;
        txtPin3.secureTextEntry = YES;
        txtPin4.secureTextEntry = YES;
        
        switchbtn.on = NO;
       
    }
}
#pragma mark button click event
-(IBAction)btnBack_click:(id)sender
{
//    LoginVC *vc = [[LoginVC alloc]init];
//    [self presentViewController:vc animated:YES completion:nil];
    UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                        message:@"Do you want to leave this page?"
                                                       delegate:self
                                              cancelButtonTitle:@"YES"
                                              otherButtonTitles:@"NO", nil];
    CheckAlert.tag = 1;
    [CheckAlert show];
}
-(IBAction)btnSubmit_click:(id)sender
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
    }
    
    
    if (txtFname.text.length==0 || txtLname.text.length==0 || txtEmailAddress.text.length==0 || txtMobileNo.text.length==0 || txtDateOfBirth.text.length==0 || txtPin1.text.length==0 || txtPin2.text.length==0 || txtPin3.text.length==0 || txtPin4.text.length == 0 || txtAnswer.text.length == 0)
    {
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"Something went wrong. Please try again later."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
        
        if (txtFname.text.length>0 && txtFname.text.length <2)
        {
            [txtFname setTextColor:[UIColor redColor]];
        }
        else if (txtFname.text.length == 0)
        {
             [txtFname setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        else{}
        
        if (txtLname.text.length>0 && txtLname.text.length <2)
        {
            [txtLname setTextColor:[UIColor redColor]];
        }
        else if (txtLname.text.length == 0)
        {
            [txtLname setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        else{}
        
        if (txtMobileNo.text.length>0 && txtMobileNo.text.length <2)
        {
            [txtMobileNo setTextColor:[UIColor redColor]];
        }
        else if (txtMobileNo.text.length == 0)
        {
            [txtMobileNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        else{}
        
        if (txtAnswer.text.length>0 && txtAnswer.text.length <3)
        {
            [txtAnswer setTextColor:[UIColor redColor]];
        }
        else if (txtAnswer.text.length == 0)
        {
            [txtAnswer setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        else{}
        
        if(txtEmailAddress.text.length == 0)
        {
            [txtEmailAddress setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        NSDate *now = [NSDate date];
        if([now timeIntervalSinceDate:pickerDateOfBirth.date] > 0 )
        {
            //         [txtDateOfBirth setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            //        [txtDateOfBirth setTextColor:[UIColor redColor]];
            
        }
        else if (txtDateOfBirth.text.length == 0)
        {
            [txtDateOfBirth setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        else
        {
            NSLog(@"picker date .. :%@ ",pickerDateOfBirth.date);
        }
    }
    else
    {
        BOOL isValid = [self NSStringIsValidEmail:txtEmailAddress.text];
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


-(IBAction)btnDob_click:(id)sender
{
    [self.txtDateOfBirth endEditing:YES];
    [self.txtDateOfBirth resignFirstResponder];
    [pickerDateOfBirth setHidden:NO];
    [btnSubmit setHidden:YES];
}
-(IBAction)btnSecurityQuestion_click:(id)sender
{
    self.scrollview.userInteractionEnabled = NO ;
    [self.view setBackgroundColor:[UIColor grayColor]];
    [viewSecurityQuestion setHidden:NO];
}
-(IBAction)btnSecurityCancel_click:(id)sender
{
    self.scrollview.userInteractionEnabled = YES ;

    [self.viewSecurityQuestion setHidden:YES];
    [self.scrollview setBackgroundColor:[UIColor whiteColor]];
}
#pragma mark alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            LoginVC *vc = [[LoginVC alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }
        else
        {
        
        }
    }
    if(alertView .tag ==2)
    {
        if(buttonIndex == 0)
        {
        
        }
        else
        {
            HomePageVC *vc = [[HomePageVC alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}
#pragma mark textfield delegate methods
-(bool)textFieldShouldBeginEditing:(UITextField *)textField
{
    [pickerDateOfBirth setHidden:YES];
  
    if(textField.tag == 4)
    {
        [viewPickerview setHidden:NO];
        
        self.scrollview.userInteractionEnabled = NO ;
        [self.view setBackgroundColor:[UIColor grayColor]];
        
        [txtEmailAddress resignFirstResponder];
        [txtFname resignFirstResponder];
        [txtLname resignFirstResponder];
        [txtMobileNo resignFirstResponder];
        [txtOtherQuestion resignFirstResponder];
        [txtAnswer resignFirstResponder];
        [txtPin1 resignFirstResponder];
        [txtPin2 resignFirstResponder];
        [txtPin3 resignFirstResponder];
        [txtPin4 resignFirstResponder];
        [pickerDateOfBirth setHidden:NO];
    } 
//    activeTextField=textField;
    if(textField == txtEmailAddress)
    {
        [txtEmailAddress setKeyboardType:UIKeyboardTypeEmailAddress];
        [txtEmailAddress reloadInputViews];
    }
    else if (textField == txtMobileNo)
    {
        [txtMobileNo setKeyboardType:UIKeyboardTypeDecimalPad];
        [txtMobileNo reloadInputViews];
    }
    else if(textField == txtDateOfBirth)
    {
        [self.txtDateOfBirth endEditing:YES];
        [self.txtDateOfBirth resignFirstResponder];
        [pickerDateOfBirth setHidden:NO];
        [btnSubmit setHidden:YES];
    }
    else if(textField == txtDateOfBirth)
    {
        [viewPickerview setHidden:NO];
        self.scrollview.userInteractionEnabled = NO ;
        [self.view setBackgroundColor:[UIColor grayColor]];
        
        if(IsIphone5)
        {
            [self.txtDateOfBirth endEditing:YES];
            [self.txtDateOfBirth resignFirstResponder];
           
           
            [pickerDateOfBirth setHidden:NO];
            [btnSubmit setHidden:YES];
        }
        else
        {
            [self.txtDateOfBirth endEditing:YES];
            [self.txtDateOfBirth resignFirstResponder];
           
            pickerDateOfBirth.frame = CGRectMake(0, 270, 320, pickerDateOfBirth.frame.size.height);
          
            [pickerDateOfBirth setHidden:NO];
            [btnSubmit setHidden:YES];
        }
    }
    else if (textField.tag == 6 || textField.tag == 7 || textField.tag == 8 || textField.tag == 9)
    {
        [txtMobileNo setKeyboardType:UIKeyboardTypeDecimalPad];
        [txtMobileNo reloadInputViews];
    }
    else
    {
        [txtFname setKeyboardType:UIKeyboardTypeDefault];
        [txtFname reloadInputViews];
    }
    int y=0;
    // txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,380,300,30)];
    if(textField == txtOtherQuestion)
    {
        y=50;
        // txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,300,300,30)];
    }
    if(textField == txtAnswer)
    {
        y=80;
        [btnSubmit setHidden:NO];
    }
    NSLog(@"y = %d",y);
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:scrollview];
        rc.origin.x = 0 ;
        rc.origin.y = y ;
        CGPoint pt=rc.origin;
        [self.scrollview setContentOffset:pt animated:YES];
    }completion:nil];
    return YES;
}
//-(void)dateDoneClicked {
//   
//    
//    //format date
//    NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
//    [FormatDate setLocale: [NSLocale currentLocale]];
//    
//    //set date format
//    [FormatDate setDateFormat:@"YYYY-MM-dd"];
//    bAge = YES;
//    dob = [FormatDate stringFromDate:[timePicker date]];
//    age = [DatabaseExtra getAge:[timePicker date]];
//    
//    datePickerSelectedDate = [timePicker date];
//    
//    self.txtAge.text = [NSString stringWithFormat:@"%ld yrs", (long)[DatabaseExtra getAge:[timePicker date]]];
//    
//    timePicker.frame=CGRectMake(0, 44, 320, 416);
//    [self cancelClicked];
//}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
    [pickerDateOfBirth setHidden:YES];
    activeTextField=textField;
    if(textField.tag == 4)
    {
         [viewPickerview setHidden:NO];
        self.scrollview.userInteractionEnabled = NO ;
        [self.view setBackgroundColor:[UIColor grayColor]];
        
        [txtEmailAddress resignFirstResponder];
        [txtFname resignFirstResponder];
        [txtLname resignFirstResponder];
        [txtMobileNo resignFirstResponder];
        [txtOtherQuestion resignFirstResponder];
        [txtAnswer resignFirstResponder];
        [txtPin1 resignFirstResponder];
        [txtPin2 resignFirstResponder];
        [txtPin3 resignFirstResponder];
        [txtPin4 resignFirstResponder];
        [pickerDateOfBirth setHidden:NO];
        
       
        
        // Open DatePicker when age textfield is clicked
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake ( 0.0, 44.0, 0.0, 0.0)];
        timePicker.backgroundColor = [UIColor whiteColor];
       dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        timePicker.maximumDate = [NSDate date];
        
        
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

        
      
        
    }
    if(textField == txtEmailAddress)
    {
        [txtEmailAddress setKeyboardType:UIKeyboardTypeEmailAddress];
        [txtEmailAddress reloadInputViews];
    }
    else if (textField == txtMobileNo)
    {
        [txtMobileNo setKeyboardType:UIKeyboardTypeDecimalPad];
        [txtMobileNo reloadInputViews];
        [btnSubmit setHidden:NO];
    }
    else if(textField == txtDateOfBirth)
    {
         [viewPickerview setHidden:NO];
        self.scrollview.userInteractionEnabled = NO ;
        [self.view setBackgroundColor:[UIColor grayColor]];
       if(IsIphone5)
       {
        [self.txtDateOfBirth endEditing:YES];
        [self.txtDateOfBirth resignFirstResponder];
       
        [pickerDateOfBirth setHidden:NO];
        [btnSubmit setHidden:YES];
       }
        else
        {
            [self.txtDateOfBirth endEditing:YES];
            [self.txtDateOfBirth resignFirstResponder];
            pickerDateOfBirth.frame = CGRectMake(0, 270, 320, pickerDateOfBirth.frame.size.height);
            
            [pickerDateOfBirth setHidden:NO];
            [btnSubmit setHidden:YES];
        }
    }
    
    else if (textField.tag == 6 || textField.tag == 7 || textField.tag == 8 || textField.tag == 9)
    {
        [txtMobileNo setKeyboardType:UIKeyboardTypeDecimalPad];
        [txtMobileNo reloadInputViews];
    }
    else
    {
        [txtFname setKeyboardType:UIKeyboardTypeDefault];
        [txtFname reloadInputViews];
    }
    int y=0;
    // txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,380,300,30)];
    if(textField == txtOtherQuestion)
    {
        y=50;
        // txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,300,300,30)];
    }
    if(textField == txtAnswer)
    {
        y=70;
        [btnSubmit setHidden:NO];
    }
    NSLog(@"y = %d",y);
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:scrollview];
        rc.origin.x = 0 ;
        rc.origin.y = y ;
        CGPoint pt=rc.origin;
        [self.scrollview setContentOffset:pt animated:YES];
    }completion:nil];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == txtDateOfBirth)
    {
        if([txtDateOfBirth.text isEqualToString:@""])
        {
        
        }
        else
        {
            [pickerDateOfBirth setHidden:YES];
        }
    }
    
    int y=0;
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:scrollview];
        rc.origin.x = 0 ;
        rc.origin.y = y ;
        CGPoint pt=rc.origin;
        [self.scrollview setContentOffset:pt animated:YES];
    }completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    NSLog(@"tag :: %d",nextTag);
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    if(textField.tag == 3)
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake ( 0.0, 44.0, 0.0, 0.0)];
        timePicker.backgroundColor = [UIColor whiteColor];
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        timePicker.maximumDate = [NSDate date];
        
        
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
//        
//
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
//            
//            pickerDateOfBirth.frame = CGRectMake(0, 270, 320, pickerDateOfBirth.frame.size.height);
//           
//            [pickerDateOfBirth setHidden:NO];
//            [btnSubmit setHidden:YES];
//        }
    }

    return YES;
}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    
//    [textField resignFirstResponder];
//    return YES;
//}
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    if ([string isEqualToString:@""]) {
//        
//        NSLog(@"backspace button pressed");
//        
//    }
//   
//    return YES;
//   
//}

//-(void)deleteBackward;
//{
//    [super deleteBackward];
//    NSLog(@"BackSpace Detected");
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
     if(textField == txtDateOfBirth)
    {
         [viewPickerview setHidden:NO];
        if(IsIphone5)
        {
            [self.txtDateOfBirth endEditing:YES];
            [self.txtDateOfBirth resignFirstResponder];
           
            [pickerDateOfBirth setHidden:NO];
            [btnSubmit setHidden:YES];
        }
        else
        {
            [self.txtDateOfBirth endEditing:YES];
            [self.txtDateOfBirth resignFirstResponder];
            
            pickerDateOfBirth.frame = CGRectMake(0, 270, 320, pickerDateOfBirth.frame.size.height);
          
            [pickerDateOfBirth setHidden:NO];
            [btnSubmit setHidden:YES];
        }
    }
    if(textField.tag == 6)
    {
        NSUInteger newLength = [txtPin1.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
           // return NO;
            [txtPin1 resignFirstResponder];
            [txtPin2 becomeFirstResponder];
        }
        else if (newLength == 0)
        {
            txtPin1.text = @"";
        }
        else
        {
            NSLog(@"YES");
            
            return YES;
            [txtPin1 resignFirstResponder];
            [txtPin2 becomeFirstResponder];
        }
        
       // return (newLength > 1) ? NO : YES;
    }
    else if (textField.tag == 7)
    {
        NSUInteger newLength = [txtPin2.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [txtPin2 resignFirstResponder];
            [txtPin3 becomeFirstResponder];
        }
        if(newLength == 0)
        {
            [txtPin2 resignFirstResponder];
            [txtPin1 becomeFirstResponder];
              txtPin2.text = @"";
        }
        else
        {
            [txtPin2 resignFirstResponder];
            [txtPin3 becomeFirstResponder];
        }

    }
    else if(textField.tag == 8)
    {
        NSUInteger newLength = [txtPin3.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [txtPin3 resignFirstResponder];
            [txtPin4 becomeFirstResponder];
            //return NO;
        }
        if(newLength == 0)
        {
            [txtPin3 resignFirstResponder];
            [txtPin2 becomeFirstResponder];
              txtPin3.text = @"";
        }
        else
        {
            [txtPin3 resignFirstResponder];
            [txtPin4 becomeFirstResponder];
        }

        
    }
    else if (textField.tag == 8)
    {
        NSUInteger newLength = [txtPin4.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            //return NO;
        }
       else if(newLength == 0)
        {
             txtPin4.text = @"";
            [txtPin4 resignFirstResponder];
            [txtPin3 becomeFirstResponder];
           
        }
        else
        {
            [txtPin4 resignFirstResponder];
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
    strPin = [strPin stringByAppendingString:txtPin1.text];
    strPin = [strPin stringByAppendingString:txtPin2.text];
    strPin = [strPin stringByAppendingString:txtPin3.text];
    strPin = [strPin stringByAppendingString:txtPin4.text];
    NSLog(@"strpin :: %@",strPin);
    NSString *strQuestion;
    strQuestion = @"What is your ";
    if(intques == 2)
    {
        strQuestion = [strQuestion stringByAppendingString:strQues];
        NSLog(@"ques :: %@",strQues);
    }
    else if (intques == 1)
    {
        strQuestion = txtOtherQuestion.text;
    }
    else
    {
        
    }

    WebApiController *obj=[[WebApiController alloc]init];
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:txtEmailAddress.text forKey:@"email"];
    [param setValue:strPin forKey:@"pin"];
    [param setValue:txtFname.text forKey:@"firstName"];
    [param setValue:txtLname.text forKey:@"lastName"];
    [param setValue:txtMobileNo.text forKey:@"mobileNumber"];
    [param setValue:[dateFormatter stringFromDate:pickerDateOfBirth.date] forKey:@"dob"];
    [param setValue:strGender forKey:@"gender"];
    [param setValue:strQuestion forKey:@"securityQuestion"];
    [param setValue:txtAnswer.text  forKey:@"securityAnswer"];
    [param setValue:@"ios7" forKey:@"os"];
    [param setValue:@"iPhone" forKey:@"make"];
    [param setValue:@"iPhone5,iPhone5s" forKey:@"model"];
    
    [obj callAPI_POST:@"register.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
}

-(void)service_reponse:(NSString *)apiAlias Response:(NSData *)response
{
    NSMutableArray *jsonDictionary=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Json dictionary :: %@",jsonDictionary);
    NSString *EntityID = [jsonDictionary valueForKey:@"status"];
    NSLog(@"message %@",EntityID);
    if ([EntityID isEqualToString:@"failure"])
    {
        
    }
    else
    {
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"My Wheel would like to access your current location."
                                                           delegate:self
                                                  cancelButtonTitle:@"Don't Allow"
                                                  otherButtonTitles:@"Allow", nil];
        
        CheckAlert.tag =2;
        [CheckAlert show];
    }
    [SVProgressHUD dismiss];
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
     self.scrollview.userInteractionEnabled = YES;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    if(indexPath.row == 10)
    {
        intques = 1;
        [txtOtherQuestion setHidden:NO];
       // [self.scrollview removeFromSuperview];
        [btnSecurityQuestion setTitle:[arrSecurityQuestion objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [btnSecurityQuestion setEnabled:YES];
        [btnSecurityQuestion setFrame:CGRectMake(5, 275, 300, 30)  ];
       txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,305,300,30)];
        txtAnswer  = [[UITextField alloc] initWithFrame:CGRectMake(5,400,300,30)];
        [self.scrollview addSubview:txtAnswer];
        txtOtherQuestion.borderStyle = UITextBorderStyleRoundedRect;
        txtOtherQuestion.font = [UIFont systemFontOfSize:15];
        txtOtherQuestion.keyboardType = UIKeyboardTypeDefault;
        txtOtherQuestion.returnKeyType = UIReturnKeyDefault;
        txtOtherQuestion.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtOtherQuestion.placeholder = @"Enter Question";
        txtOtherQuestion.tag = 10;
        txtOtherQuestion.delegate = self;
        
        [self.scrollview addSubview:txtOtherQuestion];
         [viewSecurityQuestion setHidden:YES];
        
    }
    
    else
    {
        intques = 2;
        NSLog(@"selected value : %@",[arrSecurityQuestion objectAtIndex:indexPath.row]);
        strQues = [arrSecurityQuestion objectAtIndex:indexPath.row];
        [btnSecurityQuestion setTitle:[arrSecurityQuestion objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [btnSecurityQuestion setEnabled:YES];
        [viewSecurityQuestion setHidden:YES];
        [txtOtherQuestion setHidden:YES];
         [txtAnswer setFrame:CGRectMake(5, 338, 300, 30)];
        
        
    }
    
    
}

@end
