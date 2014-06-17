//
//  DisclaimerViewController.m
//  CrimeStopper
//
//  Created by Asha Sharma on 05/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "DisclaimerViewController.h"
#import "LoginVC.h"
#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController
@synthesize btnIAgree;
@synthesize scroll;
@synthesize imgBackGround;

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
    if(IsIphone5)
    {
        imgBackGround.frame = CGRectMake(
                                     imgBackGround.frame.origin.x,
                                     imgBackGround.frame.origin.y, 303, 1000);
        [scroll setContentSize:CGSizeMake(320, 500)];
    }
    else
    {
        imgBackGround.frame = CGRectMake(
                                         imgBackGround.frame.origin.x,
                                         imgBackGround.frame.origin.y, 303, 630);
        [scroll setContentSize:CGSizeMake(320, 500)];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark button click event
-(IBAction)btnIAgree_click:(id)sender
{
    NSString *valueToSave = @"first";
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"first"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    LoginVC *vc = [[LoginVC alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
