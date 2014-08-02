//
//  ImParkingHereVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 05/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ImParkingHereVC : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>
{
    UITextField *activeTextField;
    UIActionSheet *sheet;
}
@property (nonatomic,retain) IBOutlet UIButton *btnVehicleName;
@property (nonatomic,retain) IBOutlet UIButton *btnHome;
@property (nonatomic,retain) IBOutlet UIView  *viewComment;
@property (nonatomic,retain) IBOutlet UITableView *tblCheckList;
@property (nonatomic,retain) IBOutlet NSMutableArray *arrCar,*arrBike,*arrcycle;
@property (nonatomic,retain) NSMutableArray *arrrandValue;
@property (nonatomic,retain) IBOutlet UILabel *lblLocation;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UIButton *btnRating;
@property (nonatomic,retain) IBOutlet UILabel *lblHeading;
@property (nonatomic,retain) NSMutableDictionary *arrVehiclePark;
@property (nonatomic,retain) IBOutlet UITextField *txtComment;
@property (nonatomic,retain) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic,retain) IBOutlet UIButton *btnDone;
@property (nonatomic,retain) IBOutlet UIView *viewLocationGuide;
@property (nonatomic,retain) IBOutlet UIButton *btnTips;

-(IBAction)btnBack_click:(id)sender;
-(IBAction)btnRating_click:(id)sender;
-(IBAction)btnTip_click:(id)sender;
-(IBAction)btnDone_click:(id)sender;
-(IBAction)btnGotit_click:(id)sender;

@end
