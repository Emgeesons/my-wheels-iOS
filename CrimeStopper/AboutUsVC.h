//
//  AboutUsVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 18/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsVC : UIViewController

@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UIButton *btnCall;
@property (nonatomic,retain) IBOutlet UIButton *btnWebsite;
@property (nonatomic,retain) IBOutlet UIScrollView *scroll;

-(IBAction)btnBack_click:(id)sender;
-(IBAction)btnCall_click:(id)sender;
-(IBAction)btnWebsite_click:(id)sender;

@end
