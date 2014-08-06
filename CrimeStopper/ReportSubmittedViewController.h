//
//  ReportSubmittedViewController.h
//  CrimeStopper
//
//  Created by Yogesh Suthar on 07/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportSubmittedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnReportSummary;
@property (nonatomic, strong) NSString *vehicleID;
@end
