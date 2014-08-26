//
//  LoginWithFacebookVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 13/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "LoginWithFacebookVC.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "HomePageVC.h"
#import "LoginVC.h"

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface LoginWithFacebookVC () <UIActionSheetDelegate>
{
    UIActionSheet *actionSheet, *QuestionPicker;

    AppDelegate *appdelegate;
}
@end

@implementation LoginWithFacebookVC
@synthesize btnBack,btnSubmit,btnSecurityQuestion;
@synthesize txtAnswer,txtMobileNo,txtPin1,txtPin2,txtPin3,txtPin4,txtSecurityQuestion;
@synthesize switchPin;
@synthesize arrSecurityQuestion;
@synthesize mainView,viewSecurityQuestion,scrollview;
NSString *strBirthDate;
NSString *strSecQuestion;
NSString *strQues;
int intques;

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
    [viewSecurityQuestion setHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    arrSecurityQuestion = [[NSMutableArray alloc]init];
    [arrSecurityQuestion addObject:@"security questions"];
    [arrSecurityQuestion addObject:@"passport number"];
    [arrSecurityQuestion addObject:@"licence number"];
    [arrSecurityQuestion addObject:@"mother's maiden name"];
    [arrSecurityQuestion addObject:@"first pet's name"];
    [arrSecurityQuestion addObject:@"first childhood friend"];
    [arrSecurityQuestion addObject:@"first primary school"];
    [arrSecurityQuestion addObject:@"colour of your first car"];
    [arrSecurityQuestion addObject:@"all time favourite movie"];
    [arrSecurityQuestion addObject:@"first paid job"];
    [arrSecurityQuestion addObject:@"other"];
    
    [self.txtAnswer setDelegate:self];
    [self.txtMobileNo setDelegate:self];
    [self.txtPin1 setDelegate:self];
    [self.txtPin2 setDelegate:self];
    [self.txtPin3 setDelegate:self];
    [self.txtPin4 setDelegate:self];
    [txtOtherQuestion setDelegate:self];
    
    if(IsIphone5)
    {
        
        scrollview.contentSize = CGSizeMake(320, 800);
    }
    else
    {
        
        
        scrollview.contentSize = CGSizeMake(320, 700);
    }
    // self.txtDateOfBirth.inputView = self.pickerDateOfBirth;
    [_toolbar setFrame:CGRectMake(0, -30, 320, 40)];
    // [txtDateOfBirth setInputAccessoryView:self.toolbar];
    
    [txtAnswer setInputAccessoryView:self.toolbar];
  
    [txtMobileNo setInputAccessoryView:self.toolbar];
    [txtOtherQuestion setInputAccessoryView:self.toolbar];
    [txtPin1 setInputAccessoryView:self.toolbar];
    [txtPin2 setInputAccessoryView:self.toolbar];
    [txtPin3 setInputAccessoryView:self.toolbar];
    [txtPin4 setInputAccessoryView:self.toolbar];
    [txtOtherQuestion setInputAccessoryView:self.toolbar];


    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark button click event
-(IBAction)btnBack_click:(id)sender
{
    LoginVC *vc = [[LoginVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
    
    
    
    if (txtMobileNo.text.length==0 || txtPin1.text.length==0 || txtPin2.text.length==0 || txtPin3.text.length==0 || txtPin4.text.length == 0 || txtAnswer.text.length == 0 || txtSecurityQuestion.text.length == 0)
    {
        if (txtMobileNo.text.length == 0)
        {
            [txtMobileNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        if (txtAnswer.text.length == 0)
        {
            [txtAnswer setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        if(txtPin1.text.length==0 || txtPin2.text.length==0 || txtPin3.text.length==0 || txtPin4.text.length == 0 )
        {
            [_lblPin setTextColor:[UIColor redColor]];
        }
        if(txtSecurityQuestion.text.length == 0)
        {
            [txtSecurityQuestion setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
    }
        
        
       else if (txtMobileNo.text.length>0 && txtMobileNo.text.length <2)
        {
            [txtMobileNo setTextColor:[UIColor redColor]];
        }
        else if (txtMobileNo.text.length == 0)
        {
            [txtMobileNo setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        
        
       else if (txtAnswer.text.length>0 && txtAnswer.text.length <3)
        {
            [txtAnswer setTextColor:[UIColor redColor]];
        }
        else if (txtAnswer.text.length == 0)
        {
            [txtAnswer setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        else
        {
            [self submit];
        }
        
    }
   
   

}
-(IBAction)btnSecurityQuestion_click:(id)sender
{
    self.mainView.userInteractionEnabled = NO ;
    [self.mainView setBackgroundColor:[UIColor grayColor]];
    [viewSecurityQuestion setHidden:NO];
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
    self.mainView.userInteractionEnabled = YES;
    [self.mainView setBackgroundColor:[UIColor whiteColor]];
    if(indexPath.row == 10)
    {
        intques = 1;
        [txtOtherQuestion setHidden:NO];
        // [self.scrollview removeFromSuperview];
        [btnSecurityQuestion setTitle:[arrSecurityQuestion objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [btnSecurityQuestion setEnabled:YES];
        [btnSecurityQuestion setFrame:CGRectMake(5, 210, 300, 30)  ];
        txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,250,300,30)];
        [txtAnswer setFrame:CGRectMake(5, 290, 300, 30)];
        // [self.scrollview addSubview:txtAnswer];
        txtOtherQuestion.borderStyle = UITextBorderStyleRoundedRect;
        txtOtherQuestion.font = [UIFont systemFontOfSize:15];
        txtOtherQuestion.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0];
        //  [txtOtherQuestion setBackgroundColor:[UIColor colorWithRed:170 green:170 blue:170 alpha:1]];
        txtOtherQuestion.keyboardType = UIKeyboardTypeDefault;
        txtOtherQuestion.returnKeyType = UIReturnKeyDefault;
        txtOtherQuestion.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtOtherQuestion.placeholder = @"enter question *";
        txtOtherQuestion.tag = 6;
        txtOtherQuestion.delegate = self;
        
        [self.scrollview addSubview:txtOtherQuestion];
        [viewSecurityQuestion setHidden:YES];
        
    }
    
    else
    {
        intques = 2;
        [txtOtherQuestion setHidden:YES];
        NSLog(@"selected value : %@",[arrSecurityQuestion objectAtIndex:indexPath.row]);
        strQues = [arrSecurityQuestion objectAtIndex:indexPath.row];
        [btnSecurityQuestion setTitle:[arrSecurityQuestion objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [btnSecurityQuestion setEnabled:YES];
        [viewSecurityQuestion setHidden:YES];
        [txtOtherQuestion setHidden:YES];
        [btnSecurityQuestion setFrame:CGRectMake(5, 210, 300, 30)  ];
        [txtAnswer setFrame:CGRectMake(5, 250, 300, 30)];
        
        
    }
    
    
}
#pragma mark switch button method
- (IBAction) toggleOnForSwitch:(id) sender
{
    if (switchPin.on)
    {
        txtPin1.secureTextEntry = NO;
        txtPin2.secureTextEntry = NO;
        txtPin3.secureTextEntry = NO;
        txtPin4.secureTextEntry = NO;
        NSLog(@"switch is off");
        switchPin.on = YES;
    }
    else
    {
        NSLog(@"switch is on..");
        txtPin1.secureTextEntry = YES;
        txtPin2.secureTextEntry = YES;
        txtPin3.secureTextEntry = YES;
        txtPin4.secureTextEntry = YES;
        
        switchPin.on = NO;
        
    }
}
#pragma mark textfield delegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
      activeTextField=textField;
    if(textField == txtSecurityQuestion)
    {
        [txtSecurityQuestion resignFirstResponder];
        
        QuestionPicker = [[UIActionSheet alloc] initWithTitle:@"security questions" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"passport number",@"licence number",@"mother's maiden name",@"first pet's name",@"first childhood friend",@"first primary school",@"colour of your first car",@"all time favourite movie",@"first paid job",@"other", nil];
        QuestionPicker.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        [QuestionPicker showInView:self.view];
    }
    if(textField == txtPin1 || textField == txtPin2 || textField == txtPin3 || textField == txtPin4)
    {
        [_lblPin setTextColor:[UIColor blackColor]];
    }
    int y=0;
     [textField setTextColor:[UIColor blackColor]];
    if(textField == txtOtherQuestion)
    {
        y=140;
    }
    if(textField == txtAnswer)
    {
        y=140;
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
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 2)
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
        //        else
        //        {
        //            NSLog(@"YES");
        //
        //            return YES;
        //            [txtPin1 resignFirstResponder];
        //            [txtpin2 becomeFirstResponder];
        //        }
        
        // return (newLength > 1) ? NO : YES;
    }
    else if (textField.tag == 3)
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
            txtPin2.text = @"";
            
            [txtPin2 resignFirstResponder];
            [txtPin1 becomeFirstResponder];
        }
        //        else
        //        {
        //            [txtpin2 resignFirstResponder];
        //            [txtpin3 becomeFirstResponder];
        //        }
        
    }
    else if(textField.tag == 4)
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
            txtPin3.text = @"";
            [txtPin3 resignFirstResponder];
            [txtPin2 becomeFirstResponder];
            
        }
        //        else
        //        {
        //            [txtpin3 resignFirstResponder];
        //            [txtPint4 becomeFirstResponder];
        //        }
        
        
    }
    else if (textField.tag == 5)
    {
        NSUInteger newLength = [txtPin4.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [txtPin4 resignFirstResponder];
            //return NO;
        }
        else if(newLength == 0)
        {
            [txtPin3 becomeFirstResponder];
            
            txtPin4.text = @"";
            [txtPin4 resignFirstResponder];
            
        }
        //        else
        //        {
        //            [txtPint4 resignFirstResponder];
        //        }
    }    return 1;
}
#pragma mark - UIActionSheet done/cancel buttons

-(void)actionSheet:(UIActionSheet *)actionSheet1 clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet1 == QuestionPicker) {
        if (buttonIndex == 9) {
            intques = 1;
            [txtOtherQuestion setHidden:NO];
            // [self.scrollview removeFromSuperview];
            txtSecurityQuestion.text = @"other";
            [txtSecurityQuestion setFrame:CGRectMake(5, 210, 300, 30)  ];
            txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(5,250,300,30)];
            [txtAnswer setFrame:CGRectMake(5, 290, 300, 30)];
            // [self.scrollview addSubview:txtAnswer];
            txtOtherQuestion.borderStyle = UITextBorderStyleRoundedRect;
            txtOtherQuestion.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:15];
            txtOtherQuestion.backgroundColor = [UIColor colorWithRed:240.0/255.0f green:240.0/255.0f blue:240.0/255.0f alpha:1.0];
            //  [txtOtherQuestion setBackgroundColor:[UIColor colorWithRed:170 green:170 blue:170 alpha:1]];
            txtOtherQuestion.keyboardType = UIKeyboardTypeDefault;
            txtOtherQuestion.returnKeyType = UIReturnKeyDefault;
            txtOtherQuestion.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            txtOtherQuestion.placeholder = @"enter question *";
            txtOtherQuestion.tag = 11;
            txtOtherQuestion.delegate = self;
            
            [self.scrollview addSubview:txtOtherQuestion];
            [viewSecurityQuestion setHidden:YES];
        }
        else if (buttonIndex == 10)
        {
            // [self.txtSecurityQuestion setText:@""];
            return;
        }
        else
        {
            NSString *title = [QuestionPicker buttonTitleAtIndex:buttonIndex];
            [self.txtSecurityQuestion setText:title];
            intques = 2;
            [txtOtherQuestion setHidden:YES];
            NSString *title1 = [QuestionPicker buttonTitleAtIndex:buttonIndex];
            [self.txtSecurityQuestion setText:title1];
            [btnSecurityQuestion setEnabled:YES];
            [viewSecurityQuestion setHidden:YES];
            [txtOtherQuestion setHidden:YES];
            [txtSecurityQuestion setFrame:CGRectMake(5, 210, 300, 30)  ];
            [txtAnswer setFrame:CGRectMake(5, 250, 300, 30)];
            
            if(buttonIndex == 0 ||buttonIndex == 1 || buttonIndex == 2 || buttonIndex == 3)
            {
                NSString *str = @"What's your ";
                NSString *str1 = [str stringByAppendingString:txtSecurityQuestion.text];
                strSecQuestion = [str1 stringByAppendingString:@" ?"];
            }
            else if (buttonIndex == 4)
            {
                
                strSecQuestion = @"Who was your First Childhood Friend ?";
            }
            else if (buttonIndex == 5)
            {
                
                strSecQuestion = @"What Primary School did you First Attend ?";
            }
            else if (buttonIndex == 6)
            {
                strSecQuestion = @"What was the Colour of your First Car ?";
            }
            else if (buttonIndex == 7)
            {
                strSecQuestion = @"What is your All Time Favourite Movie ?";
            }
            else if (buttonIndex == 8)
            {
                strSecQuestion = @"What was your First Paid Job ?";
            }

            
            
        }
    }
    
}

#pragma mark call api and chack validation
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
    NSString *strQuestion1;
    NSLog(@"strquestion : %@",strSecQuestion);
    strQuestion1 = @"What is your ";
    if(intques == 2)
    {
        strQuestion1 = strSecQuestion;
        NSLog(@"ques :: %@",strQues);
    }
    else if (intques == 1)
    {
        strQuestion1 = txtOtherQuestion.text;
    }
    else
    {
        
    }    /*
     email
     userId
     oldPin
     pin
     mobileNumber
     securityQuestion
     securityAnswer
     os
     make
     model

     */
   // WebApiController *obj=[[WebApiController alloc]init];
        
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:appdelegate.strFacebookEmail forKey:@"email"];
    [param setValue:strPin forKey:@"pin"];
   
    [param setValue:txtMobileNo.text forKey:@"mobileNumber"];
    [param setValue:appdelegate.strUserID forKey:@"userId"];
    [param setValue:appdelegate.strOldPin forKey:@"oldPin"];
    [param setValue:strQuestion1 forKey:@"securityQuestion"];
    [param setValue:txtAnswer.text  forKey:@"securityAnswer"];
    [param setValue:OS_VERSION forKey:@"os"];
    [param setValue:MAKE forKey:@"make"];
    [param setValue:[DeviceInfo platformNiceString] forKey:@"model"];
    
    NSLog(@"param : %@",param);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
     NSString *url = [NSString stringWithFormat:@"%@fbCompleteRegistration.php", SERVERNAME];
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              
              NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
              
              NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
              NSLog(@"data : %@",jsonDictionary);
              NSString *EntityID = [jsonDictionary valueForKey:@"status"];
              NSLog(@"message %@",EntityID);
              if ([EntityID isEqualToString:@"success"])
              {
                
                  appdelegate.Time = [NSDate date];
                  [[NSUserDefaults standardUserDefaults] setValue:txtMobileNo.text forKey:@"mobile_number"];
                  [[NSUserDefaults standardUserDefaults] setValue:@"30" forKey:@"profile_completed"];
                  [[NSUserDefaults standardUserDefaults] setValue:txtAnswer.text forKey:@"security_answer"];
                  [[NSUserDefaults standardUserDefaults] setValue:strQuestion1 forKey:@"security_question"];
                   [[NSUserDefaults standardUserDefaults] setValue:strPin forKey:@"pin"];
                  [[NSUserDefaults standardUserDefaults] setValue:txtPin1.text forKey:@"pin1"];
                  [[NSUserDefaults standardUserDefaults] setValue:txtPin2.text forKey:@"pin2"];
                  [[NSUserDefaults standardUserDefaults] setValue:txtPin3.text forKey:@"pin3"];
                  [[NSUserDefaults standardUserDefaults] setValue:txtPin4.text forKey:@"pin4"];
                  appdelegate.intCountPushNotification = 0;
                  
                  HomePageVC *vc = [[HomePageVC alloc]init];
                  appdelegate.intReg = 1;
                  [self.navigationController pushViewController:vc animated:YES];
                  
              }
              else
              {
                 
                  NSString *strmessage = [jsonDictionary valueForKey:@"message"];
                  UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@""
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

#pragma mark alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView .tag ==2)
    {
        if(buttonIndex == 0)
        {
            
        }
        else
        {
            HomePageVC *vc = [[HomePageVC alloc]init];

            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
