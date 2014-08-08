//
//  AppDelegate.h
//  CrimeStopper
//
//  Created by Asha Sharma on 05/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAirship.h"
#import <Parse/Parse.h>
#import "PPRevealSideViewController.h"

@class HomeScreenVC;
@class HomePageVC;
@class LoginVC;
@class EvertTimePinVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate,PPRevealSideViewControllerDelegate>

@property (nonatomic, retain) UINavigationController *nav;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HomeScreenVC *HomeScreenVC;
@property (nonatomic,strong) HomePageVC *homePage;
@property (nonatomic,strong) LoginVC *login;
@property (nonatomic,strong) EvertTimePinVC *everyTimeLogin;

@property (nonatomic) NSInteger intud;
@property (nonatomic,retain) NSString *strUserID;
@property (nonatomic,retain) NSString *strFBUserName;
@property (nonatomic,retain) NSString *strFBdob;
@property (nonatomic,retain) NSString *strGender;
@property (nonatomic,retain) NSString *strFacebookID;
@property (nonatomic,retain) NSString *strFacebookToken;
@property (nonatomic,retain) NSString *strFacebookPhotoURL;
@property (nonatomic,retain) NSString *strFacebookEmail;
@property (nonatomic,retain) NSString *strOldPin;
@property (nonatomic,retain) NSString *strVehicleId;
@property (nonatomic,retain) NSString *strVehicleType;
@property (nonatomic,retain) NSMutableArray *arrMutvehiclePark;
@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
@property (nonatomic) int *years;
@property (nonatomic,retain) NSString *strPhotoURL;
@property (nonatomic) NSInteger intReg;
@property (nonatomic,retain) NSString *strPinTimeStamp;
@property (nonatomic,retain) NSString *strCurrentTime;
@property (nonatomic) NSInteger intMparking;
@property (nonatomic) NSInteger intCountPushNotification;

@end
