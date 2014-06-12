//
//  AppDelegate.h
//  CrimeStopper
//
//  Created by Asha Sharma on 05/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class HomeScreenVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HomeScreenVC *HomeScreenVC;
@property (nonatomic) NSInteger intud;
@property (nonatomic,retain) NSString *strUserID;
@property (nonatomic,retain) NSString *strFBUserName;
@property (nonatomic,retain) NSString *strFBdob;
@property (nonatomic,retain) NSString *strGender;

@end
