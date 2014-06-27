//
//  AddDetailsVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 27/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "AddDetailsVC.h"
#import "UserProfileVC.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface AddDetailsVC ()

@end

@implementation AddDetailsVC
@synthesize toolbar;

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
     [self.txtlicenceno setDelegate:self];
    [self.txtPostCode setDelegate:self];
    [self.txtStreet setDelegate:self];
    
    [toolbar setFrame:CGRectMake(0, -30, 320, 40)];
    
    [_txtlicenceno setInputAccessoryView:self.toolbar];
    [_txtStreet setInputAccessoryView:self.toolbar];
    [_txtPostCode setInputAccessoryView:self.toolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark button click event
-(IBAction)btnBack_click:(id)sender
{
    UserProfileVC *vc = [[UserProfileVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(IBAction)btnSave_click:(id)sender
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
    
    
    if (_txtlicenceno.text.length==0 || _txtPostCode.text.length==0 || _txtStreet.text.length==0 )
    {
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"Something went wrong. Please try again later."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
        
        if (_txtlicenceno.text.length>0 && _txtlicenceno.text.length <2)
        {
            [_txtlicenceno setTextColor:[UIColor redColor]];
        }
        else if (_txtlicenceno.text.length == 0)
        {
            [_txtlicenceno setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        else{}
        
        if (_txtPostCode.text.length>0 && _txtPostCode.text.length <2)
        {
            [_txtPostCode setTextColor:[UIColor redColor]];
        }
        else if (_txtPostCode.text.length == 0)
        {
            [_txtPostCode setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        else{}
        
        if (_txtStreet.text.length>0 && _txtStreet.text.length <2)
        {
            [_txtStreet setTextColor:[UIColor redColor]];
        }
        else if (_txtStreet.text.length == 0)
        {
            [_txtStreet setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        else{}
        
    }
    else
    {
        /*userId
         pin
         latitude
         longitude
         licenceNo
         address
         pincode
         os
         make
         model
*/
//        [[NSUserDefaults standardUserDefaults] setValue:latitude forKey:@"latitude"];
//        [[NSUserDefaults standardUserDefaults] setValue:longitude forKey:@"longitude"];

        NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
        NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:@"pin"];
        NSString *latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"];
        NSString *longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"];
        
        NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
        [param setValue:UserID forKey:@"userId"];
        [param setValue:pin forKey:@"pin"];
        [param setValue:latitude forKey:@"latitude"];
        [param setValue:longitude forKey:@"longitude"];
        [param setValue:_txtlicenceno.text forKey:@"licenceNo"];
        [param setValue:_txtStreet.text forKey:@"address"];
        [param setValue:_txtPostCode.text forKey:@"pincode"];
        [param setValue:@"ios7" forKey:@"os"];
        [param setValue:@"iPhone" forKey:@"make"];
        [param setValue:@"iPhone5,iPhone5s" forKey:@"model"];
        
        // [obj callAPI_POST:@"register.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager POST:@"http://emgeesonsdevelopment.in/crimestoppers/mobile1.0/profileAddDetails.php" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
            
            NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
            NSLog(@"data : %@",jsonDictionary);
            
            NSString *EntityID = [jsonDictionary valueForKey:@"status"];
            NSLog(@"message %@",EntityID);
            if ([EntityID isEqualToString:@"failure"])
            {
                UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                                    message:@"Something went wrong. Please Try Again."
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                [CheckAlert show];
            }
            else
            {
                
                              
                NSString *strProfileCompleted = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"profile_completed"];
                [[NSUserDefaults standardUserDefaults] setValue:strProfileCompleted forKey:@"profile_completed"];
                [[NSUserDefaults standardUserDefaults] setValue:_txtlicenceno.text forKey:@"license_no"];
                [[NSUserDefaults standardUserDefaults] setValue:_txtStreet.text forKey:@"street"];
                [[NSUserDefaults standardUserDefaults] setValue:_txtPostCode.text forKey:@"postcode"];
                
                UserProfileVC *vc = [[UserProfileVC alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            [SVProgressHUD dismiss];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@ ***** %@", operation.responseString, error);
        }];
        
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

    }
}
#pragma mark textfeild delegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
  
    activeTextField=textField;
}
#pragma mark toolbarr's button click event
- (IBAction)btnMinimize_Click:(id)sender
{
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

@end
