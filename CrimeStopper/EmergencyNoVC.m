//
//  EmergencyNoVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 18/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "EmergencyNoVC.h"
#import "HomePageVC.h"
#import "NavigationHomeVC.h"

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface EmergencyNoVC ()

@end

@implementation EmergencyNoVC

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

    if(IsIphone5)
    {
        
        
        
    }
    else
    {
//        self.viewPoliceAss.frame = CGRectMake(0,50, 320, 109);
//        self.viewRaaRoad.frame = CGRectMake(0,150, 320, 109);
//        self.viewTow.frame = CGRectMake(0,279, 320, 109);
//        self.viewTow.frame = CGRectMake(0,388, 320, 109);

    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark button click event
-(IBAction)btnBack_click:(id)sender
{
    NavigationHomeVC *obj = [[NavigationHomeVC alloc] initWithNibName:@"NavigationHomeVC" bundle:[NSBundle mainBundle]];
    [self.revealSideViewController pushViewController:obj onDirection:PPRevealSideDirectionLeft withOffset:50 animated:YES];

}
-(IBAction)btnPoliceAssistance_click:(id)sender
{
    [self dialNumber:@"131444"];
}
-(IBAction)btnRAARoadSideService_click:(id)sender
{
    [self dialNumber:@"131111"];
}
-(IBAction)btnTowTruck_click:(id)sender
{
    [self dialNumber:@"82315555"];
}
-(IBAction)btnSuburbanTaxis_click:(id)sender
{
    [self dialNumber:@"131008"];
}

#pragma mark calling function
- (void) dialNumber:(NSString*) number{
	number = [@"tel://" stringByAppendingString:number];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}
@end
