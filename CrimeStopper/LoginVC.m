//
//  LoginVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 05/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "LoginVC.h"
#import "HomeScreenVC.h"
#import "WebApiController.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "RegistrationVC.h"

@interface LoginVC ()

@end

@implementation LoginVC
@synthesize btnFacebook,btnHomePage,btnLogin,btnRegister;
@synthesize viewButtons,viewLogin;
@synthesize txtEmail,txtPin1,txtpin2,txtpin3,txtPint4;
@synthesize lblPin;
@synthesize scrollview;

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
    [scrollview setScrollEnabled:YES];
    [self.scrollview setContentSize:CGSizeMake(320, 1000)];
    [self.view addSubview:self.scrollview];
    
    CGRect frame = viewLogin.frame;
    frame.origin.x = 320;
    viewLogin.frame = frame;
    
    viewLogin.alpha = 0;
    
    CGRect frame1 = viewButtons.frame;
    frame1.origin.x = 5;
    viewButtons.frame = frame1;
    
    viewButtons.alpha = 1;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"There is no internet connection."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
    } else {
        NSLog(@"There IS internet connection");
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollview.contentSize = CGSizeMake(320, 568+50);

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark button click event
-(IBAction)btnbtnHomepage_click:(id)sender
{

}
-(IBAction)btnbtnFacebook_click:(id)sender
{

}
-(IBAction)btnbtnLogin_click:(id)sender
{
   
    CGRect basketTopFrame1 = viewButtons.frame;
       basketTopFrame1.origin.x = -320;
    CGRect basketTopFrame = viewLogin.frame;
    basketTopFrame.origin.x = 320;
    [UIView animateWithDuration:0.95 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ viewLogin.frame = basketTopFrame; } completion:^(BOOL finished){ }];
    CGRect napkinBottomFrame = viewLogin.frame;
    napkinBottomFrame.origin.x = 5;
    [UIView animateWithDuration:0.95 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{ viewLogin.frame = napkinBottomFrame; viewButtons.frame = basketTopFrame1; viewButtons.alpha = 0;
               viewLogin.alpha = 1; } completion:^(BOOL finished){}];

}
-(IBAction)btnbtnRegister_click:(id)sender
{
    RegistrationVC *vc = [[RegistrationVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
-(IBAction)btnCancel_click:(id)sender
{
    CGRect napkinBottomFrame = viewButtons.frame;
    napkinBottomFrame.origin.x = 5;
    CGRect basketTopFrame = viewLogin.frame;
    basketTopFrame.origin.x = 320;
    
    [UIView animateWithDuration:0.95 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        viewButtons.frame = napkinBottomFrame;
        viewLogin.frame = basketTopFrame;
        viewButtons.alpha = 1;
        viewLogin.alpha = 0;
    } completion:^(BOOL finished){/*done*/}];

}
-(IBAction)btnForgetPin_click:(id)sender
{

}
#pragma mark call api

-(IBAction)btnLogin_click:(id)sender
{
    [self NSStringIsValidEmail:txtEmail.text];
 
}
-(void)service_reponse:(NSString *)apiAlias Response:(NSData *)response
{
    NSMutableArray *jsonDictionary=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Json dictionary :: %@",jsonDictionary);
     NSString *EntityID = [jsonDictionary valueForKey:@"status"];
    NSLog(@"message %@",EntityID);
    if ([EntityID isEqualToString:@"failure"])
    {
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"Incorrect Email Id or Pin."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
        txtEmail.text = @"";
        txtPin1.text = @"";
        txtpin2.text = @"";
        txtpin3.text = @"";
        txtPint4.text = @"";
        [txtEmail setText:@"enter email"];
        [txtEmail setTextColor:[UIColor redColor]];
        [self.lblPin setTextColor:[UIColor redColor]];
    }
    else
    {
    }
    [SVProgressHUD dismiss];
}
#pragma mark textfield delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [txtEmail reloadInputViews];
    
    int y=0;
    if (textField==txtEmail)
    {
        y=50;
    }
    else if (textField==txtPin1)
    {
        y=70;
    }
    else if (textField==txtpin2)
    {
        y=70;
    }
    else if (textField==txtpin3)
    {
        y=70;
    }
    else if (textField==txtPint4)
    {
        y=70;
    }
   
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
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 1)
    {
        NSUInteger newLength = [txtPin1.text length] + [string length] - range.length;
        return (newLength > 1) ? NO : YES;
    }
    else if (textField.tag == 2)
    {
        NSUInteger newLength = [txtpin2.text length] + [string length] - range.length;
        return (newLength > 1) ? NO : YES;
    }
    else if(textField.tag == 3)
    {
        NSUInteger newLength = [txtpin3.text length] + [string length] - range.length;
        return (newLength > 1) ? NO : YES;
    }
    else if (textField.tag == 4)
    {
        NSUInteger newLength = [txtPint4.text length] + [string length] - range.length;
        return (newLength > 1) ? NO : YES;
    }
    else
    {
    
    }
    return 1;
}
#pragma mark call api and chack validation
-(BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    
    if([checkString length]==0)
    {
        [txtEmail setText:@"enter email"];
        [txtEmail setTextColor:[UIColor redColor]];
         [self.lblPin setTextColor:[UIColor redColor]];
        return YES;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:checkString options:0 range:NSMakeRange(0, [checkString length])];
    
   // NSLog(@"%i", regExMatches);
    if (regExMatches == 0)
    {
        NSLog(@"Invalid email...");
       
        if([txtEmail.text isEqualToString: @""])
        {
            [txtEmail setText:@"enter email"];
            [txtEmail setTextColor:[UIColor redColor]];
             [self.lblPin setTextColor:[UIColor redColor]];
        }
        else
        {
            [txtEmail setTextColor:[UIColor redColor]];
             [self.lblPin setTextColor:[UIColor redColor]];
        }
        return NO;
    }
    else
    {
        NSLog(@"valid email...");
        WebApiController *obj=[[WebApiController alloc]init];
        NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
        [param setValue:@"g@g.com" forKey:@"email"];
        [param setValue:@"1234" forKey:@"pin"];
        [param setValue:@"android 4.4.2" forKey:@"os"];
        [param setValue:@"GT-I9300" forKey:@"make"];
        [param setValue:@"samsung" forKey:@"model"];
        [obj callAPI_POST:@"login.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [txtEmail setTextColor:[UIColor blackColor]];
        [self.lblPin setTextColor:[UIColor blackColor]];
        return YES;
    }
}


@end
