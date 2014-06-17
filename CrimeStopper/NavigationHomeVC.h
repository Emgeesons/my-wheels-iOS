//
//  NavigationHomeVC.h
//  CrimeStopper
//
//  Created by Asha Sharma on 17/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NavigationHomeVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) IBOutlet UITableView *tblNavigation;
@property (nonatomic,retain) NSMutableArray *arrList;
@property (nonatomic,retain) NSMutableArray *arrImage;

@end
