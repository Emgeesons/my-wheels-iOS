//
//  ShareNewReportViewController.m
//  CrimeStopper
//
//  Created by Yogesh Suthar on 07/07/2014.
//  Copyright (c) 2014 Emgeesons. All rights reserved.
//

#import "ShareNewReportViewController.h"
@import QuartzCore;
#import "ReportSubmittedViewController.h"
#import "Parse/Parse.h"
#import "FHSTwitterEngine.h"
#import "UIColor+Extra.h"

@interface ShareNewReportViewController () <FHSTwitterEngineAccessTokenDelegate, UITextViewDelegate> {
    BOOL check;
    UIActivityIndicatorView *activityIndicator;
    UIToolbar *bgToolBar;
}
@property (weak, nonatomic) IBOutlet UITextView *tvFacebook;
@property (weak, nonatomic) IBOutlet UITextView *tvtwitter;
- (IBAction)skipClicked:(id)sender;
- (IBAction)shareClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchFacebook;
@property (weak, nonatomic) IBOutlet UISwitch *switchTwitter;
@property (strong, nonatomic) NSArray *photoArray;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)switchClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
- (IBAction)doneClicked:(id)sender;

@end

@implementation ShareNewReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set navigationBar height to 55
    CGRect frame = self.navBar.frame;
    frame.size.height = 55;
    frame.origin.y = 0;
    self.navBar.frame = frame;
    
    self.btnShare.backgroundColor = [UIColor colorWithHexString:@"#0067AD"];
    
    self.photoArray = @[self.photo1];
    
    self.tvFacebook.layer.borderWidth = 0.2f;
    self.tvFacebook.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.tvFacebook.layer.cornerRadius = 5;
    
    self.tvtwitter.layer.borderWidth = 0.2f;
    self.tvtwitter.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.tvtwitter.layer.cornerRadius = 5;
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"ZVp4v7Y6llHOWBspbTgwatpL9" andSecret:@"MQBdnkXP8hm69auT2ZkzFlVvaukULLJXg4jeXT80b8pn8SHWvT"];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    
    check = YES;
    
    // Add UIToolBar to view with alpha 0.7 for transparency
    bgToolBar = [[UIToolbar alloc] initWithFrame:self.view.frame];
    bgToolBar.barStyle = UIBarStyleBlack;
    bgToolBar.alpha = 0.7;
    bgToolBar.translucent = YES;
    
    // initialize activityIndicator and add it to UIToolBar.
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(0, 0, 40, 40);
    activityIndicator.center = self.view.center;
    [bgToolBar addSubview:activityIndicator];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextBox)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    [self.tvFacebook setInputAccessoryView:self.toolBar];
    [self.tvtwitter setInputAccessoryView:self.toolBar];
    
    ////NSLog(@"access token==> %@", [[FHSTwitterEngine sharedEngine] accessToken].description);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipClicked:(id)sender {
    [activityIndicator stopAnimating];
    [bgToolBar removeFromSuperview];
    
    if (check) {
        check = NO;
        // delete all local images
        [self deleteAllimageFiles];
        
        ReportSubmittedViewController *vc = [[ReportSubmittedViewController alloc] init];
        vc.vehicleID = self.vehicleId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)shareClicked:(id)sender {
    
    [activityIndicator startAnimating];
    
    // code for sharing on FB and Twitter
    
    if (!self.switchFacebook.on && !self.switchTwitter.on) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please select facebook or twitter to share" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        
        // Start Animating activityIndicator
        [activityIndicator startAnimating];
        
        // add bgToolbar to view
        [self.view.superview insertSubview:bgToolBar aboveSubview:self.view];
    
        // For Facebook
        if (self.switchFacebook.on) {
            [self postOnFacebook];
        }
        
        // For Twitter
        if (self.switchTwitter.on) {
            [self postOnTwitter];
        }
    }
    
    //[self skipClicked:nil];
}

-(void)postOnTwitter {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *directory = [documentsDirectoryPath stringByAppendingPathComponent:@"fileNewReport/1.png"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            NSString *tweet = self.tvtwitter.text;
            
            id returned = nil;
            
            NSString *tweetWithhashTag = [NSString stringWithFormat:@"%@ #MyWheels", tweet];
            
            if (![self.photo1 isEqualToString:@""]) {
                returned = [[FHSTwitterEngine sharedEngine] postTweet:tweetWithhashTag withImageData:[NSData dataWithContentsOfFile:directory]];
            } else {
                returned = [[FHSTwitterEngine sharedEngine] postTweet:tweetWithhashTag];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if ([returned isKindOfClass:[NSError class]]) {

            } else {
                //NSLog(@"%@",returned);
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    /*UIAlertView *av = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];*/
                    [self skipClicked:nil];
                }
            });
        }
    });
}

-(void)postOnFacebook {
    
    //NSString *test = [NSString stringWithFormat:@"%@ #MyWheels", self.tvFacebook.text];
    
    [self makeRequestToUpdateStatus:self.tvFacebook.text title:nil description:nil image:self.photo1 link:@"https://itunes.apple.com/au/app/mywheels-australia/id914228666?ls=1&mt=8"];
}

- (void)makeRequestToUpdateStatus:(NSString *)message title:(NSString *)title description:(NSString *)description image:(NSString *)image link:(NSString *)link {
    // Put together the dialog parameters
    NSMutableDictionary *params = nil;
    
    if (![self.photo1 isEqualToString:@""]) {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      message, @"message", image, @"picture", link , @"link", nil];
    } else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      message, @"message", nil];
    }
    
    // Make the request
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  [self skipClicked:nil];
                              } else {
                                  //NSLog(@"%@", error.description);
                                  [activityIndicator stopAnimating];
                              }
                          }];
}

-(void)deleteAllimageFiles {
    // Delete all user's body picks from gallery folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *directory = [documentsDirectoryPath stringByAppendingPathComponent:@"fileNewReport/"];
    NSError *error = nil;
    for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
        BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
        if (!success || error) {
            // it failed.
            [activityIndicator stopAnimating];
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [self.tvFacebook resignFirstResponder];
        [self.tvtwitter resignFirstResponder];
    }
}

- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

-(void)resignTextBox {
    [self.tvFacebook resignFirstResponder];
    [self.tvtwitter resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - UITextView delegate methods

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (textView == self.tvtwitter) {
        if ([DeviceInfo isIphone5]) {
            [self.scrollView setContentOffset:CGPointMake(0, 110) animated:YES];
        } else {
            [self.scrollView setContentOffset:CGPointMake(0, 195) animated:YES];
        }
    } else if (textView == self.tvFacebook) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}

- (IBAction)switchClicked:(id)sender {
    if (sender == self.switchFacebook) {
        if (self.switchFacebook.on) {
            if (FBSession.activeSession.isOpen)
            {
                // post to wall
                ////NSLog(@"post to wall");
                // Do Nothing
            } else {
                // try to open session with existing valid token
                NSArray *permissions = @[@"publish_actions"];
                FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
                [FBSession setActiveSession:session];
                if([FBSession openActiveSessionWithAllowLoginUI:NO]) {
                    // post to wall
                    ////NSLog(@"post to wall");
                    // Do Nothing
                } else {
                    // you need to log the user
                    //NSLog(@"you need to log the user");
                    NSArray *permissions = @[@"publish_actions"];
                    FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
                    [FBSession setActiveSession:session];
                    [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView completionHandler:^(FBSession *sess, FBSessionState status, NSError *error) {
                        [FBSession setActiveSession:sess];
                        // Do Nothing
                    }];
                }
            }
        }
    } else if (sender == self.switchTwitter) {
        if (self.switchTwitter.on) {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"] == NULL) {
                // open login page
                UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
                    // Do Nothing
                }];
                [self presentViewController:loginController animated:YES completion:nil];
            } else {
                // Do Nothing
            }
        }
    }
}
- (IBAction)doneClicked:(id)sender {
    [self resignTextBox];
}
@end
