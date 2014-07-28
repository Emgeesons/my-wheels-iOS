//
//  AppDelegate.m
//  CrimeStopper
//
//  Created by Asha Sharma on 05/06/14.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeScreenVC.h"
#import <Parse/Parse.h>
#import "HomePageVC.h"
#import "LoginVC.h"
#import "UAConfig.h"
#import "UAPush.h"
#import "EvertTimePinVC.h"
#import "HomePageVC.h"

@implementation AppDelegate
@synthesize intud;
@synthesize strUserID;
@synthesize strFBdob,strFBUserName,strGender;
@synthesize strFacebookID,strFacebookPhotoURL,strFacebookToken,strFacebookEmail;
@synthesize strVehicleId,strVehicleType,years;
@synthesize strPhotoURL,intReg;
@synthesize strCurrentTime,strPinTimeStamp;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
   
    // Fill in with your Parse credentials:

   [Parse setApplicationId:@"XEJRREg9kvUAeqzbjuvqfrDofehrvDb5B6KGKTP1" clientKey:@"qRlZDFVX2IBS2g6Jincpez9duwfqawT5y9mubesr"];    
    // Your Facebook application id is configured in Info.plist.
    
    [PFFacebookUtils initializeFacebook];

    //cancel local notification
   [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Override point for customization after application launch.
    // Override point for customization after application launch.
    self.HomeScreenVC = [[HomeScreenVC alloc] initWithNibName:@"HomeScreenVC" bundle:nil];
    self.window.rootViewController = self.HomeScreenVC;
    
    HomeScreenVC *obj = [[HomeScreenVC alloc] initWithNibName:@"HomeScreenVC" bundle:nil];
    self.HomeScreenVC = obj;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:obj];
    self.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
    [self.revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionContentView | PPRevealSideInteractionNavigationBar];
    self.window.rootViewController = self.revealSideViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    [self.window makeKeyAndVisible];
//    self.window.rootViewController = self.HomeScreenVC;

    _arrMutvehiclePark = [[NSMutableArray alloc]init];
    
    UAConfig *config = [UAConfig defaultConfig];
    [UAirship takeOff:config];
    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert);
    [UAPush setDefaultPushEnabledValue:NO];
    // This will trigger the proper registration or de-registration code in the library.
    //[[UAPush shared] setPushEnabled:YES];

    
    return YES;
}
#pragma mark background methods
- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    application.applicationIconBadgeNumber = 0;
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

#pragma mark - PPRevealSideViewController delegate

- (void)pprevealSideViewController:(PPRevealSideViewController *)controller willPushController:(UIViewController *)pushedController {
    PPRSLog(@"%@", pushedController);
    //    [UIView animateWithDuration:0.3
    //                     animations:^{
    //                         _iOS7UnderStatusBar.alpha = 1.0;
    //                     }];
}

- (void)pprevealSideViewController:(PPRevealSideViewController *)controller didPushController:(UIViewController *)pushedController {
    PPRSLog(@"%@", pushedController);
}

- (void)pprevealSideViewController:(PPRevealSideViewController *)controller willPopToController:(UIViewController *)centerController {
    PPRSLog(@"%@", centerController);
    //    [UIView animateWithDuration:0.3
    //                     animations:^{
    //                         _iOS7UnderStatusBar.alpha = 0.0;
    //                     }];
}

- (void)pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController {
    PPRSLog(@"%@", centerController);
}

- (void)pprevealSideViewController:(PPRevealSideViewController *)controller didChangeCenterController:(UIViewController *)newCenterController {
    PPRSLog(@"%@", newCenterController);
}

- (BOOL)pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateDirectionGesture:(UIGestureRecognizer *)gesture forView:(UIView *)view {
    return NO;
}

- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController *)controller directionsAllowedForPanningOnView:(UIView *)view {
    if ([view isKindOfClass:NSClassFromString(@"UIWebBrowserView")]) return PPRevealSideDirectionLeft | PPRevealSideDirectionRight;
    
    return PPRevealSideDirectionLeft | PPRevealSideDirectionRight | PPRevealSideDirectionTop | PPRevealSideDirectionBottom;
}

- (void)pprevealSideViewController:(PPRevealSideViewController *)controller didManuallyMoveCenterControllerWithOffset:(CGFloat)offset
{
}

#pragma mark - Unloading tests

- (void)unloadRevealFromMemory {
    self.revealSideViewController = nil;
    self.window.rootViewController = nil;
}

// App switching methods to support Facebook Single Sign-On.

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [[PFFacebookUtils session] close];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"wlcome to crime stoper....");
     NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    if(UserID == nil || UserID == (id)[NSNull null] || [UserID isEqualToString:@""])
    {
        LoginVC *vc = [[LoginVC alloc] initWithNibName:@"LoginVC" bundle:nil];
        [vc.navigationController pushViewController:vc animated:YES];
     }
    else
    {
        EvertTimePinVC *vc = [[EvertTimePinVC alloc]init];
        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
        
        
    }
    //[self.nav pushViewController:vc animated:YES];
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



@end
