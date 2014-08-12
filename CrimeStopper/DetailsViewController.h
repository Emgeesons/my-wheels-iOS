//
//  DetailsViewController.h
//  CrimeStopper
//
//  Created by Yogesh Suthar on 11/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) NSString *testID;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic, strong) NSString *firstNameHeader, *vehicleHeader, *makeHeader, *modelHeader, *typeSightingHeader, *regNoHeader, *dateHeader, *timeHeader, *locationHeader, *commentHeader, *photo1Header, *photo2Header, *photo3Header, *vehicleID;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navBarHeightConstraint;

@end
