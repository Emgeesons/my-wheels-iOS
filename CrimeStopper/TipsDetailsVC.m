//
//  TipsDetailsVC.m
//  CrimeStopper
//
//  Created by Asha Sharma on 20/08/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "TipsDetailsVC.h"
#import "RatingTipsVC.h"

@interface TipsDetailsVC ()

@end

@implementation TipsDetailsVC

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
    
   
    
    _lblLocation.text = _strLocation;
    _lblRating.text = _strRating;
    NSString *str = [_strTips stringByAppendingString:@"\n"];
    NSString *str1 = [str stringByAppendingString:_strdate];
    _lblTips.text = str1;
    
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
    RatingTipsVC *vc = [[RatingTipsVC alloc]init];
    vc.strLocation = _lblLocation.text;
    vc.strrating = _lblRating.text;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
