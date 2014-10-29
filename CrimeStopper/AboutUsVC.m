//
//  AboutUsVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 18/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "AboutUsVC.h"
#import "HomePageVC.h"

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface AboutUsVC ()

@end

@implementation AboutUsVC

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
        _scroll.frame = CGRectMake(0  , 205, 320,330 );
         self.scroll.contentSize = CGSizeMake(320, 530);
      
        
    }
    else
    {
        
            _scroll.frame = CGRectMake(4 , 235, 320, 257);
        
            self.scroll.contentSize = CGSizeMake(320, 470);
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark buttopn click event
-(IBAction)btnBack_click:(id)sender
{
    //HomePageVC *vc = [[HomePageVC alloc]init];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)btnCall_click:(id)sender
{
    [self dialNumber:@"1800333000"];
}
-(IBAction)btnWebsite_click:(id)sender
{
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://sa.crimestoppers.com.au"]];
}

#pragma mark calling function
- (void) dialNumber:(NSString*) number{
	number = [@"tel://" stringByAppendingString:number];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
}
@end
