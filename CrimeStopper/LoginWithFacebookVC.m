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

@interface LoginWithFacebookVC ()
{
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
    
    [self.txtAnswer setDelegate:self];
    [self.txtMobileNo setDelegate:self];
    [self.txtPin1 setDelegate:self];
    [self.txtPin2 setDelegate:self];
    [self.txtPin3 setDelegate:self];
    [self.txtPin4 setDelegate:self];
    
    
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
    }
    
    
    if (txtMobileNo.text.length==0 || txtPin1.text.length==0 || txtPin2.text.length==0 || txtPin3.text.length==0 || txtPin4.text.length == 0 || txtAnswer.text.length == 0)
    {
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"Something went wrong. Please try again later."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
        
       
        
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
        
        }
    else
    {
        [self submit];
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
    self.mainView.userInteractionEnabled = YES;
    [self.mainView setBackgroundColor:[UIColor whiteColor]];
    if(indexPath.row == 10)
    {
        intques = 1;
        [txtOtherQuestion setHidden:NO];
//        [self.scrollview removeFromSuperview];
        [btnSecurityQuestion setTitle:[arrSecurityQuestion objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        [btnSecurityQuestion setEnabled:YES];
        [btnSecurityQuestion setFrame:CGRectMake(5, 200, 300, 30)  ];
        txtOtherQuestion  = [[UITextField alloc] initWithFrame:CGRectMake(20,250,300,30)];
        txtAnswer  = [[UITextField alloc] initWithFrame:CGRectMake(20,400,300,30)];
        [self.mainView addSubview:txtAnswer];
        txtOtherQuestion.borderStyle = UITextBorderStyleRoundedRect;
        txtOtherQuestion.font = [UIFont systemFontOfSize:15];
        txtOtherQuestion.keyboardType = UIKeyboardTypeDefault;
        txtOtherQuestion.returnKeyType = UIReturnKeyDefault;
        txtOtherQuestion.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txtOtherQuestion.placeholder = @"Enter Question";
        txtOtherQuestion.delegate = self;
        
        [self.mainView addSubview:txtOtherQuestion];
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
        [txtAnswer setFrame:CGRectMake(20, 273, 300, 30)];
        
        
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
    int y=0;
     [textField setTextColor:[UIColor blackColor]];
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
        else
        {
            NSLog(@"YES");
            
            return YES;
            [txtPin1 resignFirstResponder];
            [txtPin2 becomeFirstResponder];
        }
        
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
    else if (textField.tag == 5)
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
    /*
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
    [param setValue:@"asha@emgeesons.com" forKey:@"email"];
    [param setValue:strPin forKey:@"pin"];
   
    [param setValue:txtMobileNo.text forKey:@"mobileNumber"];
    [param setValue:appdelegate.strUserID forKey:@"userId"];
    [param setValue:appdelegate.strOldPin forKey:@"oldPin"];
    [param setValue:strQuestion forKey:@"securityQuestion"];
    [param setValue:txtAnswer.text  forKey:@"securityAnswer"];
    [param setValue:@"ios7" forKey:@"os"];
    [param setValue:@"iPhone" forKey:@"make"];
    [param setValue:@"iPhone5,iPhone5s" forKey:@"model"];
    
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
              if ([EntityID isEqualToString:@"invalid"])
              {
                  NSString *strmessage = [jsonDictionary valueForKey:@"message"];
                  UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                                      message:strmessage
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil, nil];
                  [CheckAlert show];
              }
              else
              {
                 
                  NSLog(@"Json dictionary :: %@",jsonDictionary);
                  NSString *EntityID = [jsonDictionary valueForKey:@"status"];
                  NSLog(@"message %@",EntityID);
                  if ([EntityID isEqualToString:@"failure"])
                  {
                      
                  }
                  else
                  {
                      NSString *userID =  [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"user_id"];
                    
                      [[NSUserDefaults standardUserDefaults] setValue:txtMobileNo.text forKey:@"mobile_number"];
                      [[NSUserDefaults standardUserDefaults] setValue:@"30" forKey:@"profile_completed"];
                      [[NSUserDefaults standardUserDefaults] setValue:txtAnswer.text forKey:@"security_answer"];
                      [[NSUserDefaults standardUserDefaults] setValue:strQuestion forKey:@"security_question"];
                      
                      UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                                          message:@"My Wheel would like to access your current location."
                                                                         delegate:self
                                                                cancelButtonTitle:@"Don't Allow"
                                                                otherButtonTitles:@"Allow", nil];
                      
                      
                      
                      CheckAlert.tag =2;
                      [CheckAlert show];

                  }
                 

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
