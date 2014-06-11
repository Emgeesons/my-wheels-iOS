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
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)callDisclaimer:(NSTimer *)theTimer 
{
    
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"first"];
    NSLog(@"str1 : %@",savedValue);
    if([savedValue isEqualToString:@"first"])
    {
        NSLog(@"second time... ");
        LoginVC *vc = [[LoginVC alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
       
    }
    else
    {
        DisclaimerViewController *vc = [[DisclaimerViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
