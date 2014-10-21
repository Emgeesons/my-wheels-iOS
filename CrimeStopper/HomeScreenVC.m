//
//  HomeScreenVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 05/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "HomeScreenVC.h"
#import "DisclaimerViewController.h"
#import "LoginVC.h"
#import "HomePageVC.h"
#import "EvertTimePinVC.h"
#import "APPViewController.h"

@interface HomeScreenVC ()
{
    AppDelegate *appdelegate;
}
@end

@implementation HomeScreenVC
@synthesize str;

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
    
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(callDisclaimer:) userInfo:nil repeats:NO];
    appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.navigationController.navigationBarHidden = YES;
    
    
    // Do any additional setup after loading the view from its nib.98
}
//hdgfdhfhg
-(void)callDisclaimer:(NSTimer *)theTimer 
{
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"first"];
    //NSLog(@"str1 : %@",savedValue);
    if([savedValue isEqualToString:@"first"])
    {
        //NSLog(@"second time... ");
        NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
        //NSLog(@"str : %@",UserID);
        if(UserID == nil || UserID == (id)[NSNull null])
        {
            APPViewController *vc = [[APPViewController alloc]init];
            //DisclaimerViewController *vc = [[DisclaimerViewController alloc]init];
            //        [self presentViewController:vc animated:YES completion:nil];
            [self.navigationController pushViewController:vc animated:YES];

        }
        else
        {
            HomePageVC *vc = [[HomePageVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }

       
    }
    else
    {
        APPViewController *vc = [[APPViewController alloc]init];
        //DisclaimerViewController *vc = [[DisclaimerViewController alloc]init];
//        [self presentViewController:vc animated:YES completion:nil];
         [self.navigationController pushViewController:vc animated:YES];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btn_lik:(id)sender
{
    EvertTimePinVC *vc = [[EvertTimePinVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
