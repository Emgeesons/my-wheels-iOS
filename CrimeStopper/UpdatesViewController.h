//
//  UpdatesViewController.h
//  CrimeStopper
//
//  Created by Yogesh Suthar on 11/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatesViewController : UIViewController
@property (nonatomic,retain) IBOutlet UIView *viewLocation;

-(IBAction)btnLocation_click:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnLetsGo;

@end
