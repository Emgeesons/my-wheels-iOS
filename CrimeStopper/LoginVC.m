
#import "LoginVC.h"
#import "HomeScreenVC.h"
#import "WebApiController.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "RegistrationVC.h"
#import "HomePageVC.h"
#import "UserDetailsViewController.h"
#import "SVProgressHUD.h"
#import "LoginWithFacebookVC.h"

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface LoginVC ()
{
    AppDelegate *appdelegate;
}

@end

@implementation LoginVC
@synthesize btnFacebook,btnHomePage,btnLogin,btnRegister;
@synthesize viewButtons,viewLogin;
@synthesize txtEmail,txtPin1,txtpin2,txtpin3,txtPint4;
@synthesize lblPin;
@synthesize scrollview;
@synthesize txtEmailIDForForgot;
@synthesize btnCancel,btnSubmit;
@synthesize viewForgotPin;
@synthesize lblQuestion,txtAnswer,btnForgotPinCancel,btnForgotPinSubmit,viewForgotQuestion;
@synthesize imgBackGround;
@synthesize imgvehicals;

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
    self.title = @"Facebook Profile";
    
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:NO];
    }
    
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [scrollview setScrollEnabled:YES];
    [self.scrollview setContentSize:CGSizeMake(320, 1000)];
    [self.view addSubview:self.scrollview];
//    [self.viewButtons setHidden:NO];
    CGRect frame = viewLogin.frame;
    frame.origin.x = 320;
    viewLogin.frame = frame;
    
    viewLogin.alpha = 0;
    
    CGRect frame1 = viewButtons.frame;
    frame1.origin.x = 5;
    viewButtons.frame = frame1;
    
    viewButtons.alpha = 1;
    
    CGRect frame2 = viewButtons.frame;
    frame2.origin.x = 320;
    viewButtons.frame = frame2;
    viewForgotPin.alpha = 0;
    
    CGRect frame3 = viewButtons.frame;
    frame3.origin.x = 320;
    viewButtons.frame = frame1;
    viewForgotQuestion.alpha = 0;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"There IS NO internet connection");
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:@"There is no internet connection."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
    }
    else
    {
        NSLog(@"There IS internet connection");
    }
    if(IsIphone5)
    {
        imgBackGround.frame = CGRectMake(
                                         imgBackGround.frame.origin.x,
                                         imgBackGround.frame.origin.y, 320,720);
        
        
        
        imgvehicals.frame = CGRectMake(imgvehicals.frame.origin.x,310, 270,40);
        
        viewButtons.frame = CGRectMake(20, 350, 283, 238);
        viewForgotPin.frame = CGRectMake(20, 350, 283, 238);
        viewForgotQuestion.frame = CGRectMake(20, 350, 283, 238);
        viewLogin.frame = CGRectMake(20, 350, 283, 238);
        
        self.scrollview.contentSize = CGSizeMake(320, 770);
    }
    else
    {
        imgBackGround.frame = CGRectMake(
                                         imgBackGround.frame.origin.x,
                                         imgBackGround.frame.origin.y, 320, 680);
        
        imgvehicals.frame = CGRectMake(imgvehicals.frame.origin.x,300, 270,40);
        
        viewButtons.frame = CGRectMake(20, 340, 283, 238);
        viewForgotPin.frame = CGRectMake(20, 340, 283, 238);
        viewForgotQuestion.frame = CGRectMake(20, 340, 283, 238);
        viewLogin.frame = CGRectMake(20, 340, 283, 238);
        
        self.scrollview.contentSize = CGSizeMake(320, 700);
    }

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(IsIphone5)
    {
        imgBackGround.frame = CGRectMake(
                                         imgBackGround.frame.origin.x,
                                         imgBackGround.frame.origin.y, 320,720);
        
  
        
        imgvehicals.frame = CGRectMake(imgvehicals.frame.origin.x,310, 270,40);
        
        viewButtons.frame = CGRectMake(20, 350, 283, 238);
        viewForgotPin.frame = CGRectMake(20, 350, 283, 238);
        viewForgotQuestion.frame = CGRectMake(20, 350, 283, 238);
        viewLogin.frame = CGRectMake(20, 350, 283, 238);
        
        self.scrollview.contentSize = CGSizeMake(320, 770);
    }
    else
    {
        imgBackGround.frame = CGRectMake(
                                         imgBackGround.frame.origin.x,
                                         imgBackGround.frame.origin.y, 320, 680);
        
        imgvehicals.frame = CGRectMake(imgvehicals.frame.origin.x,300, 270,40);
        
        viewButtons.frame = CGRectMake(20, 340, 283, 238);
        viewForgotPin.frame = CGRectMake(20, 340, 283, 238);
        viewForgotQuestion.frame = CGRectMake(20, 340, 283, 238);
        viewLogin.frame = CGRectMake(20, 340, 283, 238);
        
         self.scrollview.contentSize = CGSizeMake(320, 700);
    }
   

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
- (IBAction)loginButtonTouchHandler:(id)sender
{
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        } else {
            NSLog(@"User with facebook logged in!");
            
//            [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
            UserDetailsViewController *vc = [[UserDetailsViewController alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
    
    [_activityIndicator startAnimating]; // Show loading indicator until login is finished}

//    LoginWithFacebookVC *vc = [[LoginWithFacebookVC alloc]init];
//    [self presentViewController:vc animated:YES completion:nil];
}
-(IBAction)btnbtnLogin_click:(id)sender
{
   
    CGRect basketTopFrame1 = viewButtons.frame;
       basketTopFrame1.origin.x = -320;
    CGRect basketTopFrame = viewLogin.frame;
    basketTopFrame.origin.x = 320;
    [UIView animateWithDuration:0.95 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ viewLogin.frame = basketTopFrame; } completion:^(BOOL finished){ }];
    CGRect napkinBottomFrame = viewLogin.frame;
    napkinBottomFrame.origin.x = 20;
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
    napkinBottomFrame.origin.x = 20;
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
    CGRect basketTopFrame1 = viewLogin.frame;
    basketTopFrame1.origin.x = -320;
    CGRect basketTopFrame = viewForgotPin.frame;
    basketTopFrame.origin.x = 320;
    [UIView animateWithDuration:0.95 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ viewForgotPin.frame = basketTopFrame; } completion:^(BOOL finished){ }];
    CGRect napkinBottomFrame = viewForgotPin.frame;
    napkinBottomFrame.origin.x = 20;
    [UIView animateWithDuration:0.95 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{ viewForgotPin.frame = napkinBottomFrame; viewLogin.frame = basketTopFrame1; viewLogin.alpha = 0;
        viewForgotPin.alpha = 1; } completion:^(BOOL finished){}];
}
-(IBAction)btnForgotSbmit_click:(id)sender
{
     [self NSStringIsValidEmail:txtEmailIDForForgot.text];
}
-(IBAction)btnForgotCancel_click:(id)sender
{
    
    CGRect napkinBottomFrame = viewLogin.frame;
    napkinBottomFrame.origin.x = 20;
    CGRect basketTopFrame = viewForgotPin.frame;
    basketTopFrame.origin.x = 320;
    
    [UIView animateWithDuration:0.95 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        viewLogin.frame = napkinBottomFrame;
        viewForgotPin.frame = basketTopFrame;
        viewLogin.alpha = 1;
        viewForgotPin.alpha = 0;
    } completion:^(BOOL finished){/*done*/}];

}
-(IBAction)btnForgotPinSubmit_click:(id)sender
{
    WebApiController *obj=[[WebApiController alloc]init];
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:appdelegate.strUserID forKey:@"userId"];
    [param setValue:txtAnswer.text forKey:@"securityAnswer"];
    [param setValue:@"iOS7" forKey:@"os"];
    [param setValue:@"iPhone" forKey:@"make"];
    [param setValue:@"iPhone5,iPhone5S" forKey:@"model"];
    [obj callAPI_POST:@"forgotPinAnswer.php" andParams:param SuccessCallback:@selector(service_reponseForgorPinAnswer:Response:) andDelegate:self];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
}
-(IBAction)btnForgotPinCancel_click:(id)sender
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
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Couldn't finish"
                                                            message:@"Username or PIN incorrect."
                                                           delegate:self
                                                  cancelButtonTitle:@"Edit details"
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
        appdelegate.strUserID = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"userId"];
        
        HomePageVC *vc = [[HomePageVC alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    [SVProgressHUD dismiss];
}
-(void)service_reponseForgorPin:(NSString *)apiAlias Response:(NSData *)response
{
    NSMutableArray *jsonDictionary=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Json dictionary :: %@",jsonDictionary);
    NSString *EntityID = [jsonDictionary valueForKey:@"status"];
    NSLog(@"message %@",EntityID);
    if ([EntityID isEqualToString:@"failure"])
    {
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Incorrect Email"
                                                            message:@"EmailID You entered is incorrect. Please try again with the correct emailID."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
        [CheckAlert show];
        txtEmailIDForForgot.text = @"";
       
        [txtEmailIDForForgot setTextColor:[UIColor redColor]];
    }
    else
    {
         NSString *respinse = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"security_question"];
        appdelegate.strUserID = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"userId"];
        NSLog(@"response :: %@",respinse);
      
        
        CGRect basketTopFrame1 = viewForgotPin.frame;
        basketTopFrame1.origin.x = -320;
        CGRect basketTopFrame = viewForgotQuestion.frame;
        basketTopFrame.origin.x = 320;
        [UIView animateWithDuration:0.95 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{ viewForgotQuestion.frame = basketTopFrame; } completion:^(BOOL finished){ }];
        CGRect napkinBottomFrame = viewForgotQuestion.frame;
        napkinBottomFrame.origin.x = 20;
        [UIView animateWithDuration:0.95 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{ viewForgotQuestion.frame = napkinBottomFrame; viewForgotPin.frame = basketTopFrame1; viewForgotPin.alpha = 0;
            viewForgotQuestion.alpha = 1; } completion:^(BOOL finished){}];
        
        lblQuestion.text = respinse;
    }
    [SVProgressHUD dismiss];
}
//service_reponseForgorPinAnswer
-(void)service_reponseForgorPinAnswer:(NSString *)apiAlias Response:(NSData *)response
{
    
    NSMutableArray *jsonDictionary=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Json dictionary :: %@",jsonDictionary);
    NSString *EntityID = [jsonDictionary valueForKey:@"status"];
    NSLog(@"message %@",EntityID);
    if ([EntityID isEqualToString:@"failure"])
    {
        
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warninga"
                                                            message:@"Incorrect Answer. Please try again."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        CheckAlert.tag =1;
        [CheckAlert show];
    }
    else
    {
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Email sent"
                                                            message:@"Change PIN has been sent to your email ID."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        CheckAlert.tag =1;
        [CheckAlert show];
    }
    [SVProgressHUD dismiss];
}
#pragma mark textfield delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [txtEmail reloadInputViews];
    
    if(textField == txtEmailIDForForgot)
    {
        [txtEmailIDForForgot setKeyboardType:UIKeyboardTypeEmailAddress];
        [txtEmailIDForForgot reloadInputViews];
    }
    int y=0;
   
//    if (textField==txtEmail)
//    {
//        y=50;
//        viewLogin.frame = CGRectMake(0, 50, viewLogin.frame.size.width, viewLogin.frame.size.height);
//
//    }
 if (textField==txtPin1)
    {
        y=170;
    }
    else if (textField == txtEmail)
    {
        y=170;
    }
    else if (textField==txtpin2)
    {
        y=170;
    }
    else if (textField==txtpin3)
    {
        y=170;
    }
    else if (textField==txtPint4)
    {
        y=170;
    }
    else if (textField == txtEmailIDForForgot)
    {
        y=200;
    }
    else if (textField == txtAnswer)
    {
        y=170;
    }
   
     //viewLogin.frame = CGRectMake(0, y, viewLogin.frame.size.width, viewLogin.frame.size.height);
//    CGRect frame = viewLogin.frame;
//    frame.origin.x = 20;
//    viewLogin.frame = frame;
    
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
        if(newLength >1)
        {
            NSLog(@"no");
            // return NO;
            [txtPin1 resignFirstResponder];
            [txtpin2 becomeFirstResponder];
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
            [txtpin2 becomeFirstResponder];
        }
        
        // return (newLength > 1) ? NO : YES;
    }
    else if (textField.tag == 2)
    {
        NSUInteger newLength = [txtpin2.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [txtpin2 resignFirstResponder];
            [txtpin3 becomeFirstResponder];
        }
        if(newLength == 0)
        {
            [txtpin2 resignFirstResponder];
            [txtPin1 becomeFirstResponder];
            txtpin2.text = @"";
        }
        else
        {
            [txtpin2 resignFirstResponder];
            [txtpin3 becomeFirstResponder];
        }
        
    }
    else if(textField.tag == 3)
    {
        NSUInteger newLength = [txtpin3.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [txtpin3 resignFirstResponder];
            [txtPint4 becomeFirstResponder];
            //return NO;
        }
        if(newLength == 0)
        {
            [txtpin3 resignFirstResponder];
            [txtpin2 becomeFirstResponder];
            txtpin3.text = @"";
        }
        else
        {
            [txtpin3 resignFirstResponder];
            [txtPint4 becomeFirstResponder];
        }
        
        
    }
    else if (textField.tag == 4)
    {
        NSUInteger newLength = [txtPint4.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            //return NO;
        }
        else if(newLength == 0)
        {
            txtPint4.text = @"";
            [txtPint4 resignFirstResponder];
            [txtpin3 becomeFirstResponder];
            
        }
        else
        {
            [txtPint4 resignFirstResponder];
        }
    }
        return 1;

}

#pragma mark call api and chack validation
-(BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    if([checkString isEqualToString:txtEmail.text])
    {
        if([checkString length]==0)
        {
            [txtEmail setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            [txtEmailIDForForgot setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            [self.lblPin setTextColor:[UIColor redColor]];
            return YES;
        }
        else
        {
        
        }
    
        NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
        NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger regExMatches = [regEx numberOfMatchesInString:checkString options:0 range:NSMakeRange(0, [checkString length])];
    
  
        if (regExMatches == 0)
        {
            NSLog(@"Invalid email...");
       
            if([txtEmail.text isEqualToString: @""])
            {
              [txtEmail setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
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
            NSString *strPin;
            strPin = @"";
            strPin = [strPin stringByAppendingString:txtPin1.text];
            strPin = [strPin stringByAppendingString:txtpin2.text];
            strPin = [strPin stringByAppendingString:txtpin3.text];
            strPin = [strPin stringByAppendingString:txtPint4.text];
            NSLog(@"strpin :: %@",strPin);
            WebApiController *obj=[[WebApiController alloc]init];
            NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
            [param setValue:txtEmail.text forKey:@"email"];
            [param setValue:strPin forKey:@"pin"];
            [param setValue:@"iOS7" forKey:@"os"];
            [param setValue:@"iPhone" forKey:@"make"];
            [param setValue:@"iPhone5,iPhone5S" forKey:@"model"];
            [obj callAPI_POST:@"login.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [txtEmail setTextColor:[UIColor blackColor]];
            [self.lblPin setTextColor:[UIColor blackColor]];
            return YES;
        }
    }
    
    
    if ([checkString isEqualToString:txtEmailIDForForgot.text])
    {
        if([checkString length]==0)
        {
           [txtEmailIDForForgot setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            return YES;
        }
        else
        {
            
        }
        if(txtEmailIDForForgot.text.length == 0)
        {
            [txtEmailIDForForgot setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        }
        NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        
        NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger regExMatches = [regEx numberOfMatchesInString:checkString options:0 range:NSMakeRange(0, [checkString length])];
        
        
        if (regExMatches == 0)
        {
            NSLog(@"Invalid email...");
            
            if([txtEmailIDForForgot.text isEqualToString: @""])
            {
                [txtEmailIDForForgot setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];                
            }
            else
            {
                [txtEmailIDForForgot setTextColor:[UIColor redColor]];
               
            }
            return NO;
        }
        else
        {
            NSLog(@"valid email...");
          
            WebApiController *obj=[[WebApiController alloc]init];
            NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
            [param setValue:txtEmailIDForForgot.text forKey:@"email"];
           
            [param setValue:@"iOS7" forKey:@"os"];
            [param setValue:@"iPhone" forKey:@"make"];
            [param setValue:@"iPhone5,iPhone5S" forKey:@"model"];
            [obj callAPI_POST:@"forgotPinEmail.php" andParams:param SuccessCallback:@selector(service_reponseForgorPin:Response:) andDelegate:self];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [txtEmailIDForForgot setTextColor:[UIColor blackColor]];
          
            return YES;
        }

    }
    return YES;
}
#pragma mark alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
}
        
@end
