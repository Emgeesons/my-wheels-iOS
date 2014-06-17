//
//  HomePageVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 10/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HomePageVC : UIViewController
@property (nonatomic,retain) IBOutlet UIButton *btnNav;

-(IBAction)btnNav_click:(id)sender;

@end
