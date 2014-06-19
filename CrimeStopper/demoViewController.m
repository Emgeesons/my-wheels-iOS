//
//  demoViewController.m
//  CrimeStopper
//
//  Created by Asha Sharma on 19/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "demoViewController.h"

@interface demoViewController ()

@end

@implementation demoViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
