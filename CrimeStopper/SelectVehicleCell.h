//
//  SelectVehicleCell.h
//  CrimeStopper
//
//  Created by Asha Sharma on 04/07/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectVehicleCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UILabel *lblMakeModel;
@property (nonatomic,retain) IBOutlet UIImageView *imgVehicleType;

@property (nonatomic,retain) IBOutlet UILabel *lblRegistrationNumber;


@end
