//
//  coachmarkVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 18/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "coachmarkVC.h"
#import "UserProfileVC.h"
@interface coachmarkVC ()

@end

@implementation coachmarkVC

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
-(IBAction)btnGo_Click:(id)sender
{
    UserProfileVC *vc = [[UserProfileVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
