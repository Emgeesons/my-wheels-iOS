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
    self.navigationController.navigationBarHidden = YES;
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
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
    
   // WebApiController *obj=[[WebApiController alloc]init];
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setValue:appdelegate.strUserID forKey:@"userId"];
    [param setValue:_lblRating.text forKey:@"rating"];
    [param setValue:_txtComment.text forKey:@"feedback"];
 
    [param setValue:@"ios7" forKey:@"os"];
    [param setValue:@"iPhone" forKey:@"make"];
    [param setValue:@"iPhone5,iPhone5s" forKey:@"model"];
    
    //[obj callAPI_POST:@"feedback.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
   NSString *url = [NSString stringWithFormat:@"%@feedback.php", SERVERNAME];
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
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
            
            UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:nil
                                                                message:@"Thank you for your feedback."
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            CheckAlert.tag = 1;
            
            [CheckAlert show];
            
        }
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
    }];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];

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
@end
