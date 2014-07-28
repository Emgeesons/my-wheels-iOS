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

@interface EvertTimePinVC ()

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
    
    
    // self.txtDateOfBirth.inputView = self.pickerDateOfBirth;
    [_toolbar setFrame:CGRectMake(0, -30, 320, 40)];
    // [txtDateOfBirth setInputAccessoryView:self.toolbar];
    
    
    [_txtPin1 setInputAccessoryView:self.toolbar];
    [_txtPin2 setInputAccessoryView:self.toolbar];
    [_txtPin3 setInputAccessoryView:self.toolbar];
    [_txtPin4 setInputAccessoryView:self.toolbar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark button click event
-(IBAction)btnForgotPin_click:(id)sender
{
//    LoginVC *vc = [[LoginVC alloc]init];
//  
//   [self.navigationController pushViewController:vc animated:YES];
    //vc.view.frame = CGRectMake(0, 0, 200, 200);
   // [self presentViewController:vc animated:YES completion:nil];
    
}
-(IBAction)btnSignInUser_click:(id)sender
{
//    LoginVC *vc = [[LoginVC alloc]init];
//    
//     [self presentViewController:vc animated:YES completion:nil];
    
}
-(IBAction)btnContinue_click:(id)sender
{
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
    NSLog(@"strpin :: %@",strPin);

    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSLog(@"str : %@",UserID);
    NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];

    
    [param setValue:UserID forKey:@"userId"];
    [param setValue:latitude forKey:@"latitude"];
    [param setValue:longitude forKey:@"longitude"];
    [param setValue:strPin forKey:@"pin"];
    [param setValue:@"ios7" forKey:@"os"];
    [param setValue:@"iPhone" forKey:@"make"];
    [param setValue:@"iPhone5,iPhone5s" forKey:@"model"];
    NSLog(@"param : %@",param);
    // [obj callAPI_POST:@"register.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
     NSString *url = [NSString stringWithFormat:@"%@verifyPin.php", SERVERNAME];
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              
              NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
              
              NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
              NSLog(@"data : %@",jsonDictionary);
              NSString *EntityID = [jsonDictionary valueForKey:@"status"];
              NSLog(@"message %@",EntityID);
              if ([EntityID isEqualToString:@"failure"])
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
//                  HomePageVC *obj = [[HomePageVC alloc] initWithNibName:@"HomePageVC" bundle:nil];
//                  self.homePage = obj;
//                  [self.navigationController pushViewController:obj animated:YES];
                  [self dismissViewControllerAnimated:YES completion:nil];
              }
              [SVProgressHUD dismiss];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@ ***** %@", operation.responseString, error);
          }];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
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
            NSLog(@"no");
            // return NO;
            [_txtPin1 resignFirstResponder];
            [_txtPin2 becomeFirstResponder];
        }
    }
    else if (textField.tag == 2)
    {
        NSUInteger newLength = [_txtPin2.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [_txtPin2 resignFirstResponder];
            [_txtPin3 becomeFirstResponder];
        }
    }
    else if(textField.tag == 3)
    {
        NSUInteger newLength = [_txtPin3.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [_txtPin3 resignFirstResponder];
            [_txtPin4 becomeFirstResponder];
            //return NO;
        }
        
    }
    else if (textField.tag == 4)
    {
        NSUInteger newLength = [_txtPin4.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [_txtPin4 resignFirstResponder];
            //return NO;
        }
       
    }
    return 1;
    
}

@end
