//
//  TipsDetailsVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 20/08/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsDetailsVC : UIViewController
@property (nonatomic,retain) IBOutlet UILabel *lblLocation,*lblRating;
@property (nonatomic,retain) IBOutlet UITextView *lblTips;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;

@property (nonatomic,retain)NSString *strLocation,*strRating,*strTips,*strdate;


-(IBAction)btnBack_click:(id)sender;

@end
