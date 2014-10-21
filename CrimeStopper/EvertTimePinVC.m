//
//  EvertTimePinVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 21/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "EvertTimePinVC.h"
#import "LoginVC.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "HomePageVC.h"
#import "Reachability.h"
#import "AppDelegate.h"

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
@interface EvertTimePinVC ()
{
    AppDelegate *appdelegate;
}
@end

@implementation EvertTimePinVC

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
    // Do any additional setup after loading the view from its nib.
    [self.txtPin1 setDelegate:self];
    [self.txtPin2 setDelegate:self];
    [self.txtPin3 setDelegate:self];
    [self.txtPin4 setDelegate:self];
    
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // self.txtDateOfBirth.inputView = self.pickerDateOfBirth;
    [_toolbar setFrame:CGRectMake(0, -30, 320, 40)];
    // [txtDateOfBirth setInputAccessoryView:self.toolbar];
    
    
    [_txtPin1 setInputAccessoryView:self.toolbar];
    [_txtPin2 setInputAccessoryView:self.toolbar];
    [_txtPin3 setInputAccessoryView:self.toolbar];
    [_txtPin4 setInputAccessoryView:self.toolbar];
    
    if(IsIphone5)
    {
        _btnSign.frame = CGRectMake(_btnSign.frame.origin.x, 500, _btnSign.frame.size.width, _btnSign.frame.size.height);
    }
    else
    {
        _btnSign.frame = CGRectMake(_btnSign.frame.origin.x, 400, _btnSign.frame.size.width, _btnSign.frame.size.height);
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark button click event
-(IBAction)btnForgotPin_click:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dob"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emergencyContact"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emergency_contact_number"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fb_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fb_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"first_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"license_no"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"license_photo_url"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile_number"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"modified_at"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"photo_url"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"postcode"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profile_completed"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"samaritan_points"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"security_question"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"street"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"suburb"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleName"];
    //parkVehicle
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"parkVehicle"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"vehicles"];
    LoginVC *vc = [[LoginVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}
-(IBAction)btnSignInUser_click:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dob"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emergencyContact"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emergency_contact_number"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fb_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fb_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"first_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"license_no"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"license_photo_url"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mobile_number"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"modified_at"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"photo_url"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"postcode"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"profile_completed"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"samaritan_points"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"security_question"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"street"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"suburb"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleName"];
    //parkVehicle
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"parkVehicle"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CurrentVehicleName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"vehicles"];
    LoginVC *vc = [[LoginVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnContinue_click:(id)sender
{
    [_txtPin1 resignFirstResponder];
        [_txtPin2 resignFirstResponder];
        [_txtPin3 resignFirstResponder];
        [_txtPin4 resignFirstResponder];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        ////NSLog(@"There IS NO internet connection");
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"Please connect to the internet to continue."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
    } else {
        ////NSLog(@"There IS internet connection");
        
        

    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    /*userId
     pin
     latitude
     longitude
     os
     make
     model
*/
    NSString *strPin;
    strPin = @"";
    strPin = [strPin stringByAppendingString:_txtPin1.text];
    strPin = [strPin stringByAppendingString:_txtPin2.text];
    strPin = [strPin stringByAppendingString:_txtPin3.text];
    strPin = [strPin stringByAppendingString:_txtPin4.text];
    ////NSLog(@"strpin :: %@",strPin);

    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    ////NSLog(@"str : %@",UserID);
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];

    
    [param setValue:UserID forKey:@"userId"];
    [param setValue:latitude forKey:@"latitude"];
    [param setValue:longitude forKey:@"longitude"];
    [param setValue:strPin forKey:@"pin"];
        [param setValue:OS_VERSION forKey:@"os"];
        [param setValue:MAKE forKey:@"make"];
        [param setValue:[DeviceInfo platformNiceString] forKey:@"model"];
    ////NSLog(@"param : %@",param);
    // [obj callAPI_POST:@"register.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   // manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
     NSString *url = [NSString stringWithFormat:@"%@verifyPin.php", SERVERNAME];
    
        //        [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //
        //        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
        [manager POST:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
  
              
              ////NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
              
              NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
              ////NSLog(@"data : %@",jsonDictionary);
              NSString *EntityID = [jsonDictionary valueForKey:@"status"];
              ////NSLog(@"message %@",EntityID);
              if ([EntityID isEqualToString:@"success"])
              {
                  appdelegate.Time = [NSDate date];
                  
                  HomePageVC *vc = [[HomePageVC alloc]init];
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
                  [CheckAlert show];              }
              [SVProgressHUD dismiss];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              ////NSLog(@"Error: %@ ***** %@", operation.responseString, error);
          }];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
}
#pragma mark toolbar button click event
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setTextColor:[UIColor blackColor]];
    
    activeTextField=textField;
    
    
   if (textField.tag == 1 || textField.tag == 2 || textField.tag == 3 || textField.tag == 4)
    {
        [textField setKeyboardType:UIKeyboardTypeDecimalPad];
        [textField reloadInputViews];
      
    }
   }

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 1)
    {
        NSUInteger newLength = [_txtPin1.text length] + [string length] - range.length;
        if(newLength >1)
        {
            ////NSLog(@"no");
            // return NO;
            [_txtPin1 resignFirstResponder];
            [_txtPin2 becomeFirstResponder];
        }
        else if (newLength == 0)
        {
            _txtPin1.text = @"";
        }
        //        else
        //        {
        //            //NSLog(@"YES");
        //
        //            return YES;
        //            [txtPin1 resignFirstResponder];
        //            [txtpin2 becomeFirstResponder];
        //        }
        
        // return (newLength > 1) ? NO : YES;
    }
    else if (textField.tag == 2)
    {
        NSUInteger newLength = [_txtPin2.text length] + [string length] - range.length;
        if(newLength >1)
        {
            ////NSLog(@"no");
            [_txtPin2 resignFirstResponder];
            [_txtPin3 becomeFirstResponder];
        }
        if(newLength == 0)
        {
            _txtPin2.text = @"";
            
            [_txtPin2 resignFirstResponder];
            [_txtPin1 becomeFirstResponder];
        }
        //        else
        //        {
        //            [txtpin2 resignFirstResponder];
        //            [txtpin3 becomeFirstResponder];
        //        }
        
    }
    else if(textField.tag == 3)
    {
        NSUInteger newLength = [_txtPin3.text length] + [string length] - range.length;
        if(newLength >1)
        {
            ////NSLog(@"no");
            [_txtPin3 resignFirstResponder];
            [_txtPin4 becomeFirstResponder];
            //return NO;
        }
        if(newLength == 0)
        {
            _txtPin3.text = @"";
            [_txtPin3 resignFirstResponder];
            [_txtPin2 becomeFirstResponder];
            
        }
        //        else
        //        {
        //            [txtpin3 resignFirstResponder];
        //            [txtPint4 becomeFirstResponder];
        //        }
        
        
    }
    else if (textField.tag == 4)
    {
        NSUInteger newLength = [_txtPin4.text length] + [string length] - range.length;
        if(newLength >1)
        {
            ////NSLog(@"no");
            [_txtPin4 resignFirstResponder];
            //return NO;
        }
        else if(newLength == 0)
        {
            [_txtPin3 becomeFirstResponder];
            
            _txtPin4.text = @"";
            [_txtPin4 resignFirstResponder];
            
        }
        //        else
        //        {
        //            [txtPint4 resignFirstResponder];
        //        }
    }
    
    return 1;
    
}

@end
