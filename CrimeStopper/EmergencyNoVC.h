//
//  EmergencyNoVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 18/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmergencyNoVC : UIViewController

@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lbl1,*lbl2,*lbl3;
@property (nonatomic,retain) IBOutlet UIView *viewPoliceAss,*viewRaaRoad,*viewTow,*viewSuburban;


-(IBAction)btnBack_click:(id)sender;
-(IBAction)btnPoliceAssistance_click:(id)sender;
-(IBAction)btnRAARoadSideService_click:(id)sender;
-(IBAction)btnTowTruck_click:(id)sender;
-(IBAction)btnSuburbanTaxis_click:(id)sender;

@end
