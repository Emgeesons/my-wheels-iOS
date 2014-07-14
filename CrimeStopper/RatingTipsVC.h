//
//  RatingTipsVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 11/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingTipsVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSDateFormatter *dateFormatter;
}

@property (nonatomic,retain) NSMutableArray *arrTips;
@property (nonatomic,retain) NSString *strLocation,*strrating;
@property (nonatomic,retain) IBOutlet UILabel *lblLocation,*lblRating;
@property (nonatomic,retain) IBOutlet UITableView *tblRating;


-(IBAction)btnBack_click:(id)sender;
@end
