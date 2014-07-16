//
//  ReportSubmittedViewController.m
//  CrimeStopper
//
//  Created by Yogesh Suthar on 07/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "ReportSubmittedViewController.h"
#import "HomePageVC.h"

@interface ReportSubmittedViewController ()
- (IBAction)reportSummaryClicked:(id)sender;

@end

@implementation ReportSubmittedViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reportSummaryClicked:(id)sender {
    
    // open report summary
    
    HomePageVC *homeVC = [[HomePageVC alloc] init];
    [self.navigationController pushViewController:homeVC animated:YES];
}
@end