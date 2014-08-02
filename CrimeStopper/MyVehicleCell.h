//
//  MyVehicleCell.h
//  CrimeStopper
//
//  Created by Asha Sharma on 03/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyVehicleCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UILabel *lblMakeModel;
@property (nonatomic,retain) IBOutlet UIImageView *imgVehicleType;
@property (nonatomic,retain) IBOutlet UIImageView *imgStatus;
@property (nonatomic,retain) IBOutlet UILabel *lblRegistrationNumber;
@property (nonatomic,retain) IBOutlet UILabel *lblStatus;
@property (nonatomic,retain) IBOutlet UILabel *lblRegNo;

@end
