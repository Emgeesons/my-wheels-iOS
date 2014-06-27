
#import "LoginVC.h"
#import "HomeScreenVC.h"
#import "SVProgressHUD.h"
#import "Reachability.h"
#import "RegistrationVC.h"
#import "HomePageVC.h"
#import "UserDetailsViewController.h"
#import "SVProgressHUD.h"
#import "LoginWithFacebookVC.h"
#import "AFNetworking.h"


//#import "PPRevealSideViewController.h"

#define   IsIphone5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface LoginVC ()
{
    AppDelegate *appdelegate;
}
//@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
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
@synthesize btnSkiptoHome;

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
    self.navigationController.navigationBarHidden = YES;
    // Check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:NO];
    }
      appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [scrollview setScrollEnabled:YES];
   // [self.scrollview setContentSize:CGSizeMake(320, 1000)];
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
        self.scrollview.frame = CGRectMake(0, -20, 320, 588);

        [self.scrollview setContentSize:CGSizeMake(320, 568)];
         imgBackGround.frame = CGRectMake(0, 0, 320, 568);
        
       viewButtons.frame = CGRectMake(19, 283, 282, 220);
       _imgView.frame = CGRectMake(0, 0, 282, 220);
        _imgView1.frame = CGRectMake(0,0, 282, 220);
        _imgView2.frame = CGRectMake(0,0, 282, 220);
        _imgView3.frame = CGRectMake(0,0, 282, 220);
        btnFacebook.frame = CGRectMake(26, 15, 230, 55);
        btnLogin.frame = CGRectMake(26, 83, 230, 55);
        btnRegister.frame = CGRectMake(26, 153, 230, 55);
       
        viewForgotPin.frame = CGRectMake(19, 283, 282, 220);
        viewForgotQuestion.frame = CGRectMake(19, 283, 282, 220);
        viewLogin.frame = CGRectMake(19, 283, 282, 220);
         btnSkiptoHome.frame = CGRectMake(19, 535, 282, 30);
        _btnCancel1.frame = CGRectMake(20, 163, 57, 30);
        _btnForgotPin.frame = CGRectMake(174, 163, 94, 30);
       // btnCancel.frame = CGRectMake(112, 168, 58, 30);
        
        
    }
    else
    {
        imgBackGround.frame = CGRectMake(0, 0, 320, 480);
        self.scrollview.frame = CGRectMake(0, -20, 320, 500);
        [self.scrollview setContentSize:CGSizeMake(320, 480)];
        viewButtons.frame = CGRectMake(19, 238, 282, 170);
        _imgView.frame = CGRectMake(0,0, 282, 200);
        _imgView1.frame = CGRectMake(0,0, 282, 200);
        _imgView2.frame = CGRectMake(0,0, 282, 200);
        _imgView3.frame = CGRectMake(0,0, 282, 200);
        btnFacebook.frame = CGRectMake(26, 15, 230, 50);
        btnLogin.frame = CGRectMake(26, 72, 230, 50);
        btnRegister.frame = CGRectMake(26, 130, 230, 50);
        
        viewForgotPin.frame = CGRectMake(19, 238, 282, 170);
        viewForgotQuestion.frame = CGRectMake(19, 238, 282, 170);
        viewLogin.frame = CGRectMake(19, 238, 282, 170);
        btnSkiptoHome.frame = CGRectMake(19, 442, 282, 30);

        //// set in 4.0
        _btnCancel1.frame = CGRectMake(20, 153, 57, 30);
        _btnForgotPin.frame = CGRectMake(174, 153, 94, 30);
       // btnCancel.frame = CGRectMake(112, 158, 58, 30);
    }
    
    [txtEmail setInputAccessoryView:self.toolbar];
    [txtAnswer setInputAccessoryView:self.toolbar];
    [txtEmailIDForForgot setInputAccessoryView:self.toolbar];
    [txtPin1 setInputAccessoryView:self.toolbar];
    [txtpin2 setInputAccessoryView:self.toolbar];
    [txtpin3 setInputAccessoryView:self.toolbar];
    [txtPint4 setInputAccessoryView:self.toolbar];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if(IsIphone5)
    {
        self.scrollview.frame = CGRectMake(0, 0, 320, 588);
        
        [self.scrollview setContentSize:CGSizeMake(320, 568)];
        imgBackGround.frame = CGRectMake(0, 0, 320, 568);
        
        viewButtons.frame = CGRectMake(19, 283, 282, 220);
        _imgView.frame = CGRectMake(0, 0, 282, 220);
        _imgView1.frame = CGRectMake(0,0, 282, 220);
        _imgView2.frame = CGRectMake(0,0, 282, 220);
        _imgView3.frame = CGRectMake(0,0, 282, 220);
        btnFacebook.frame = CGRectMake(26, 15, 230, 55);
        btnLogin.frame = CGRectMake(26, 83, 230, 55);
        btnRegister.frame = CGRectMake(26, 153, 230, 55);
        
        viewForgotPin.frame = CGRectMake(19, 283, 282, 220);
        viewForgotQuestion.frame = CGRectMake(19, 283, 282, 220);
        viewLogin.frame = CGRectMake(19, 283, 282, 220);
        btnSkiptoHome.frame = CGRectMake(19, 515, 282, 30);
        _btnCancel1.frame = CGRectMake(20, 163, 57, 30);
        _btnForgotPin.frame = CGRectMake(174, 163, 94, 30);
        btnCancel.frame = CGRectMake(112, 168, 58, 30);
        
        
    }
    else
    {
        imgBackGround.frame = CGRectMake(0, 0, 320, 480);
        self.scrollview.frame = CGRectMake(0, -20, 320, 500);
        [self.scrollview setContentSize:CGSizeMake(320, 480)];
        viewButtons.frame = CGRectMake(19, 238, 282, 170);
        _imgView.frame = CGRectMake(0,0, 282, 200);
        _imgView1.frame = CGRectMake(0,0, 282, 200);
        _imgView2.frame = CGRectMake(0,0, 282, 200);
        _imgView3.frame = CGRectMake(0,0, 282, 200);
        btnFacebook.frame = CGRectMake(26, 15, 230, 50);
        btnLogin.frame = CGRectMake(26, 72, 230, 50);
        btnRegister.frame = CGRectMake(26, 130, 230, 50);
        
        viewForgotPin.frame = CGRectMake(19, 238, 282, 170);
        viewForgotQuestion.frame = CGRectMake(19, 238, 282, 170);
        viewLogin.frame = CGRectMake(19, 238, 282, 170);
        btnSkiptoHome.frame = CGRectMake(19, 442, 282, 30);
        
        //// set in 4.0
        _btnCancel1.frame = CGRectMake(20, 153, 57, 30);
        _btnForgotPin.frame = CGRectMake(174, 153, 94, 30);
        btnCancel.frame = CGRectMake(112, 158, 58, 30);
    }

    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(IsIphone5)
    {
        self.scrollview.frame = CGRectMake(0, -20, 320, 588);
        
        [self.scrollview setContentSize:CGSizeMake(320, 568)];
        imgBackGround.frame = CGRectMake(0, 0, 320, 568);
        
        viewButtons.frame = CGRectMake(19, 283, 282, 220);
        _imgView.frame = CGRectMake(0, 0, 282, 220);
        _imgView1.frame = CGRectMake(0,0, 282, 220);
        _imgView2.frame = CGRectMake(0,0, 282, 220);
        _imgView3.frame = CGRectMake(0,0, 282, 220);
        btnFacebook.frame = CGRectMake(26, 15, 230, 55);
        btnLogin.frame = CGRectMake(26, 83, 230, 55);
        btnRegister.frame = CGRectMake(26, 153, 230, 55);
        
        viewForgotPin.frame = CGRectMake(19, 283, 282, 220);
        viewForgotQuestion.frame = CGRectMake(19, 283, 282, 220);
        viewLogin.frame = CGRectMake(19, 283, 282, 220);
        btnSkiptoHome.frame = CGRectMake(19, 515, 282, 30);
        _btnCancel1.frame = CGRectMake(20, 163, 57, 30);
        _btnForgotPin.frame = CGRectMake(174, 163, 94, 30);
        btnCancel.frame = CGRectMake(112, 168, 58, 30);
        
        
    }
    else
    {
        imgBackGround.frame = CGRectMake(0, 0, 320, 480);
        self.scrollview.frame = CGRectMake(0, -20, 320, 500);
        [self.scrollview setContentSize:CGSizeMake(320, 480)];
        viewButtons.frame = CGRectMake(19, 238, 282, 170);
        _imgView.frame = CGRectMake(0,0, 282, 200);
        _imgView1.frame = CGRectMake(0,0, 282, 200);
        _imgView2.frame = CGRectMake(0,0, 282, 200);
        _imgView3.frame = CGRectMake(0,0, 282, 200);
        btnFacebook.frame = CGRectMake(26, 15, 230, 50);
        btnLogin.frame = CGRectMake(26, 72, 230, 50);
        btnRegister.frame = CGRectMake(26, 130, 230, 50);
        
        viewForgotPin.frame = CGRectMake(19, 238, 282, 170);
        viewForgotQuestion.frame = CGRectMake(19, 238, 282, 170);
        viewLogin.frame = CGRectMake(19, 238, 282, 170);
        btnSkiptoHome.frame = CGRectMake(19, 442, 282, 30);
        
        //// set in 4.0
        _btnCancel1.frame = CGRectMake(20, 153, 57, 30);
        _btnForgotPin.frame = CGRectMake(174, 153, 94, 30);
        btnCancel.frame = CGRectMake(112, 158, 58, 30);
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
    HomePageVC *vc = [[HomePageVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
    [self.navigationController pushViewController:vc animated:YES];

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
    if(txtEmailIDForForgot.text.length == 0)
    {
        [txtEmailIDForForgot setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    else
    {
     [self NSStringIsValidEmail:txtEmailIDForForgot.text];
    }
}
-(IBAction)btnForgotCancel11_click:(id)sender
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
-(IBAction)btnForgotPinSubmit11_click:(id)sender
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
  if(txtAnswer.text.length == 0)
  {
      
      [txtAnswer setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];

  }
  else
  {
   // WebApiController *obj=[[WebApiController alloc]init];
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:appdelegate.strUserID forKey:@"userId"];
    [param setValue:txtAnswer.text forKey:@"securityAnswer"];
    [param setValue:@"iOS7" forKey:@"os"];
    [param setValue:@"iPhone" forKey:@"make"];
    [param setValue:@"iPhone5,iPhone5S" forKey:@"model"];
      AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
      manager.requestSerializer = [AFJSONRequestSerializer serializer];
      [manager POST:@"http://emgeesonsdevelopment.in/crimestoppers/mobile1.0/forgotPinAnswer.php" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
          
      } success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          
          NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
          
          NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
          NSLog(@"data : %@",jsonDictionary);
          //  NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
          
          //  NSMutableArray *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@ ***** %@", operation.responseString, error);
      }];
 
      [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
  }
    
}
-(IBAction)btnForgotPinCancel_click:(id)sender
{
    CGRect napkinBottomFrame = viewForgotPin.frame;
    napkinBottomFrame.origin.x = 20;
    CGRect basketTopFrame = viewForgotQuestion.frame;
    basketTopFrame.origin.x = 320;
    
    [UIView animateWithDuration:0.95 delay:0.0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        viewForgotPin.frame = napkinBottomFrame;
        viewForgotQuestion.frame = basketTopFrame;
        viewForgotPin.alpha = 1;
        viewForgotQuestion.alpha = 0;
    } completion:^(BOOL finished){/*done*/}];
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

#pragma mark call api

-(IBAction)btnLogin_click:(id)sender
{
    [self NSStringIsValidEmail:txtEmail.text];
    
    
}




#pragma mark textfield delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeTextField=textField;
    
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
        rc.origin.y = y-20 ;
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
        rc.origin.y = y-20 ;
        CGPoint pt=rc.origin;
        [self.scrollview setContentOffset:pt animated:YES];
    }completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

       return NO;
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
            [txtpin2 becomeFirstResponder];
        }
//        else if (newLength == 0)
//        {
//            txtPin1.text = @"";
//        }
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
        NSUInteger newLength = [txtpin2.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [txtpin2 resignFirstResponder];
            [txtpin3 becomeFirstResponder];
        }
//        if(newLength == 0)
//        {
//            [txtpin2 resignFirstResponder];
//            [txtPin1 becomeFirstResponder];
//            txtpin2.text = @"";
//        }
//        else
//        {
//            [txtpin2 resignFirstResponder];
//            [txtpin3 becomeFirstResponder];
//        }
        
    }
    else if(textField.tag == 4)
    {
        NSUInteger newLength = [txtpin3.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [txtpin3 resignFirstResponder];
            [txtPint4 becomeFirstResponder];
            //return NO;
        }
//        if(newLength == 0)
//        {
//            [txtpin3 resignFirstResponder];
//            [txtpin2 becomeFirstResponder];
//            txtpin3.text = @"";
//        }
//        else
//        {
//            [txtpin3 resignFirstResponder];
//            [txtPint4 becomeFirstResponder];
//        }
        
        
    }
    else if (textField.tag == 5)
    {
        NSUInteger newLength = [txtPint4.text length] + [string length] - range.length;
        if(newLength >1)
        {
            NSLog(@"no");
            [txtPint4 resignFirstResponder];
            //return NO;
        }
//        else if(newLength == 0)
//        {
//            txtPint4.text = @"";
//            [txtPint4 resignFirstResponder];
//            [txtpin3 becomeFirstResponder];
//            
//        }
//        else
//        {
//            [txtPint4 resignFirstResponder];
//        }
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
           // [txtEmailIDForForgot setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
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
            [[NSUserDefaults standardUserDefaults] setValue:strPin forKey:@"pin"];
            
             [[NSUserDefaults standardUserDefaults] setValue:txtPin1.text forKey:@"pin1"];
             [[NSUserDefaults standardUserDefaults] setValue:txtpin2.text forKey:@"pin2"];
             [[NSUserDefaults standardUserDefaults] setValue:txtpin3.text forKey:@"pin3"];
             [[NSUserDefaults standardUserDefaults] setValue:txtPint4.text forKey:@"pin4"];
            
          //  WebApiController *obj=[[WebApiController alloc]init];
            NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
            [param setValue:txtEmail.text forKey:@"email"];
            [param setValue:strPin forKey:@"pin"];
            [param setValue:@"iOS7" forKey:@"os"];
            [param setValue:@"iPhone" forKey:@"make"];
            [param setValue:@"iPhone5,iPhone5S" forKey:@"model"];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
             manager.requestSerializer = [AFJSONRequestSerializer serializer];
             
            
             [manager POST:@"http://emgeesonsdevelopment.in/crimestoppers/mobile1.0/login.php" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
              {
             //do not put image inside parameters dictionary as I did, but append it!
             //[formData appendPartWithFileData:imageData name:@"image" fileName:@"profilePic.png" mimeType:@"image/png"];
                  [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
             }
            success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                 NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
                NSLog(@"data : %@",jsonDictionary);
           //  NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                
              //  NSMutableArray *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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
                    [txtEmail setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                    
                    [self.lblPin setTextColor:[UIColor redColor]];
                }
                else
                {
                    NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
                    NSLog(@"data : %@",jsonDictionary);
                    appdelegate.strUserID = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"user_id"];
                    
                    NSString *dob = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"dob"];
                    NSString *email = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"email"];
                    NSString *emergencyContact = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"emergency_contact"];
                    NSString *emergency_contact_number = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"emergency_contact_number"];
                    NSString *fb_id = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"fb_id"];
                    NSString *fb_token = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"fb_token"];
                    NSString *first_name = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"first_name"];
                    NSString *gender = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"gender"];
                    NSString *last_name = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"last_name"];
                    NSString *license_no = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"license_no"];
                    NSString *license_photo_url = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"license_photo_url"];
                    NSString *mobile_number = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"mobile_number"];
                    NSString *modified_at = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"modified_at"];
                    NSString *photo_url = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"photo_url"];
                    NSString *postcode = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"postcode"];
                    NSString *profile_completed = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"profile_completed"];
                    NSString *samaritan_points = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"samaritan_points"];
                    NSString *security_answer = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"security_answer"];
                    NSString *security_question = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"security_question"];
                    NSString *street = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"street"];
                    NSString *suburb = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"suburb"];
                    
                    NSLog(@"user id: %@",appdelegate.strUserID);
                    
                    [[NSUserDefaults standardUserDefaults] setValue:appdelegate.strUserID forKey:@"UserID"];
                    [[NSUserDefaults standardUserDefaults] setValue:dob forKey:@"dob"];
                    [[NSUserDefaults standardUserDefaults] setValue:email forKey:@"email"];
                    [[NSUserDefaults standardUserDefaults] setValue:emergencyContact forKey:@"emergencyContact"];
                    [[NSUserDefaults standardUserDefaults] setValue:emergency_contact_number forKey:@"emergency_contact_number"];
                    [[NSUserDefaults standardUserDefaults] setValue:fb_id forKey:@"fb_id"];
                    [[NSUserDefaults standardUserDefaults] setValue:fb_token forKey:@"fb_token"];
                    [[NSUserDefaults standardUserDefaults] setValue:first_name forKey:@"first_name"];
                    [[NSUserDefaults standardUserDefaults] setValue:gender forKey:@"gender"];
                    [[NSUserDefaults standardUserDefaults] setValue:last_name forKey:@"last_name"];
                    [[NSUserDefaults standardUserDefaults] setValue:license_no forKey:@"license_no"];
                    [[NSUserDefaults standardUserDefaults] setValue:license_photo_url forKey:@"license_photo_url"];
                    [[NSUserDefaults standardUserDefaults] setValue:mobile_number forKey:@"mobile_number"];
                    [[NSUserDefaults standardUserDefaults] setValue:modified_at forKey:@"modified_at"];
                    [[NSUserDefaults standardUserDefaults] setValue:photo_url forKey:@"photo_url"];
                    [[NSUserDefaults standardUserDefaults] setValue:postcode forKey:@"postcode"];
                    [[NSUserDefaults standardUserDefaults] setValue:profile_completed forKey:@"profile_completed"];
                    [[NSUserDefaults standardUserDefaults] setValue:samaritan_points forKey:@"samaritan_points"];
                    [[NSUserDefaults standardUserDefaults] setValue:security_answer forKey:@"security_answer"];
                    [[NSUserDefaults standardUserDefaults] setValue:security_question forKey:@"security_question"];
                    [[NSUserDefaults standardUserDefaults] setValue:street forKey:@"street"];
                    [[NSUserDefaults standardUserDefaults] setValue:suburb forKey:@"suburb"];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    HomePageVC *obj=[[HomePageVC alloc]init];
                  
                    [self.navigationController pushViewController:obj animated:YES];
                 }
                [SVProgressHUD dismiss];

                 NSLog(@"Success: %@",responseObject);
             }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@ ***** %@", operation.responseString, error);
             }];
             
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
          
           // WebApiController *obj=[[WebApiController alloc]init];
            NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
            [param setValue:txtEmailIDForForgot.text forKey:@"email"];
           
            [param setValue:@"iOS7" forKey:@"os"];
            [param setValue:@"iPhone" forKey:@"make"];
            [param setValue:@"iPhone5,iPhone5S" forKey:@"model"];
            
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
                       [manager POST:@"http://emgeesonsdevelopment.in/crimestoppers/mobile1.0/forgotPinEmail.php" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
              
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                
                NSDictionary *jsonDictionary=(NSDictionary *)responseObject;
                NSLog(@"data : %@",jsonDictionary);
                //  NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
                
                //  NSMutableArray *jsonDictionary=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
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
                    
                    [txtEmailIDForForgot setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
                    
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

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Error: %@ ***** %@", operation.responseString, error);
            }];
            
          
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
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            
        }
    }
}
        
@end
