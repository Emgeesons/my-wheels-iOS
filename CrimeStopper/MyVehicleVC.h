//
//  MyVehicleVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 03/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyVehicleVC : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)IBOutlet UIButton *btnBack,*btnAddVehicle;
@property (nonatomic,retain) IBOutlet UITableView *tblMyVehicle;
@property (nonatomic,retain) NSDictionary *arrVehicles;

-(IBAction)btnBack_click:(id)sender;
-(IBAction)btnAddVehicle_click:(id)sender;

@end
