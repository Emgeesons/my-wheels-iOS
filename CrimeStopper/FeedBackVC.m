//
//  FeedBackVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 18/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "FeedBackVC.h"
#import "NavigationHomeVC.h"
#import "PPRevealSideViewController.h"
//#import "WebApiController.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "HomePageVC.h"
#import "AFNetworking.h"
#import "Reachability.h"

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

/*feedback.php
 Parameters to pass - userId, rating (compulsory), feedback (optional field), os, make, model.*/

@interface FeedBackVC ()
{
    AppDelegate *appdelegate;
}
@end

@implementation FeedBackVC

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
   activeTextField=_txtComment;
    //_txtComment.delegate = self;
    
    self.navigationController.navigationBarHidden = YES;
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [_txtComment setInputAccessoryView:self.toolbar];
    
    if(IsIphone5)
    {
        
        _scroll.contentSize = CGSizeMake(320, 800);
    }
    else
    {
        
        
        _scroll.contentSize = CGSizeMake(320, 700);
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark button click event
-(void)dismissKeyboard {
    [_txtComment resignFirstResponder];
}

-(IBAction)btnBack_click:(id)sender
{
    NavigationHomeVC *obj = [[NavigationHomeVC alloc] initWithNibName:@"NavigationHomeVC" bundle:[NSBundle mainBundle]];
    [self.revealSideViewController pushViewController:obj onDirection:PPRevealSideDirectionLeft withOffset:50 animated:YES];
    
}
-(IBAction) sliderChanged:(id) sender{
	
	int progressAsInt =(int)(_slide.value + 0.5f);
	NSString *newText =[[NSString alloc] initWithFormat:@"%d",progressAsInt];
	_lblRating.text = newText;
	
    }
-(IBAction)btnSend_click:(id)sender
{
    [super viewDidLoad];
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
    }
    else
    {
    
   // WebApiController *obj=[[WebApiController alloc]init];
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:UserID forKey:@"userId"];
    [param setValue:_lblRating.text forKey:@"rating"];
    [param setValue:_txtComment.text forKey:@"feedback"];
 
        [param setValue:OS_VERSION forKey:@"os"];
        [param setValue:MAKE forKey:@"make"];
        [param setValue:[DeviceInfo platformNiceString] forKey:@"model"];
    
    //[obj callAPI_POST:@"feedback.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   // manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@feedback.php", SERVERNAME];
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
            UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:nil
                                                                message:[jsonDictionary valueForKey:@"message"]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            CheckAlert.tag = 1;
            
            [CheckAlert show];
        }
        else
        {
            UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@""
                                                                message:[jsonDictionary valueForKey:@"message"]
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [CheckAlert show];
            
            
            
        }
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ////NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    }
}
- (IBAction)btnMinimize_Click:(id)sender {
    [activeTextField resignFirstResponder];
    int y=0;
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlDown animations:^{
        CGRect rc = [_txtComment bounds];
        rc = [_txtComment convertRect:rc toView:_scroll];
        rc.origin.x = 0 ;
        rc.origin.y = y ;
        CGPoint pt=rc.origin;
        [self.scroll setContentOffset:pt animated:YES];
    }completion:nil];
}
#pragma mark alert view delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
            HomePageVC *vc = [[HomePageVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            
        }
    }
    }

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_txtComment resignFirstResponder];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    int y=0;
    if (textView == _txtComment)
    {
        y=160;
    }
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionTransitionCurlUp animations:^{
        CGRect rc = [textView bounds];
        rc = [textView convertRect:rc toView:_scroll];
        rc.origin.x = 0 ;
        rc.origin.y = y-20 ;
        CGPoint pt=rc.origin;
        [self.scroll setContentOffset:pt animated:YES];
        
    }completion:nil];

    
    ////NSLog(@"Started editing target!");
    
}
@end
