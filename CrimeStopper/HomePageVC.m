//
//  HomePageVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 10/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "HomePageVC.h"
#import "AppDelegate.h"
#import "NavigationHomeVC.h"
#import "PPRevealSideViewController.h"

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface HomePageVC ()
{
    AppDelegate *appdelegate;
}
@end

@implementation HomePageVC
@synthesize btnNav;
@synthesize viewNewReport,viewReport,viewUpdates,viewAboutUs;

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
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"user id:%@",appdelegate.strUserID);
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(IsIphone5)
    {
        //scrollview.frame = CGRectMake(4 , 58, 320, 568+50);
       // self.scrollview.contentSize = CGSizeMake(320, 800);
        _map.frame = CGRectMake(0,20, 320, 270);
        _btnParking.frame = CGRectMake(1, 170, 150, 60);
        _btnVehicles.frame = CGRectMake(152, 170, 150, 60);
        viewReport.frame = CGRectMake(0, 230, 320, 60);
        viewNewReport.frame = CGRectMake(0, 290, 320, 60);
        viewUpdates.frame = CGRectMake(0, 350, 320, 60);
        viewUpdates.frame = CGRectMake(0, 410, 320, 60);
    
    }
    else
    {
        _map.frame = CGRectMake(0,20, 320, 270);
        _btnParking.frame = CGRectMake(1, 170, 150, 60);
        _btnVehicles.frame = CGRectMake(152, 170, 150, 60);
        viewReport.frame = CGRectMake(0, 230, 320, 60);
        viewNewReport.frame = CGRectMake(0, 290, 320, 60);
        viewUpdates.frame = CGRectMake(0, 350, 320, 60);
        viewUpdates.frame = CGRectMake(0, 410, 320, 60);
//        scrollview.frame = CGRectMake(4 , 58, 320, 568+50);
        
//        self.scrollview.contentSize = CGSizeMake(320, 700);
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark button click event
-(IBAction)btnNav_click:(id)sender
{
    NavigationHomeVC *obj = [[NavigationHomeVC alloc] initWithNibName:@"NavigationHomeVC" bundle:[NSBundle mainBundle]];
    [self.revealSideViewController pushViewController:obj onDirection:PPRevealSideDirectionLeft withOffset:50 animated:YES];

}
@end
