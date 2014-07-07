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

@interface ShareNewReportViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tvFacebook;
@property (weak, nonatomic) IBOutlet UITextView *tvtwitter;
- (IBAction)skipClicked:(id)sender;
- (IBAction)shareClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switchFacebook;
@property (weak, nonatomic) IBOutlet UISwitch *switchTwitter;
@property (strong, nonatomic) NSArray *photoArray;

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
    
    self.photoArray = @[self.photo1, self.photo2, self.photo3];
    
    self.tvFacebook.layer.borderWidth = 0.2f;
    self.tvFacebook.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.tvFacebook.layer.cornerRadius = 5;
    
    self.tvtwitter.layer.borderWidth = 0.2f;
    self.tvtwitter.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.tvtwitter.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipClicked:(id)sender {
    // delete all local images
    [self deleteAllimageFiles];
    
    ReportSubmittedViewController *vc = [[ReportSubmittedViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)shareClicked:(id)sender {
    
    // code for sharing on FB and Twitter
    
    // For Facebook
    if (self.switchFacebook.on) {
        if (FBSession.activeSession.isOpen)
        {
            // post to wall
            NSLog(@"post to wall");
            [self postOnFacebook];
        } else {
            // try to open session with existing valid token
            NSArray *permissions = @[@"publish_actions"];
            FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
            [FBSession setActiveSession:session];
            if([FBSession openActiveSessionWithAllowLoginUI:NO]) {
                // post to wall
                NSLog(@"post to wall");
                [self postOnFacebook];
            } else {
                // you need to log the user
                NSLog(@"you need to log the user");
                NSArray *permissions = @[@"publish_actions"];
                FBSession *session = [[FBSession alloc] initWithPermissions:permissions];
                [FBSession setActiveSession:session];
                [session openWithBehavior:FBSessionLoginBehaviorWithNoFallbackToWebView completionHandler:^(FBSession *sess, FBSessionState status, NSError *error) {
                    [FBSession setActiveSession:sess];
                    [self postOnFacebook];
                }];
            }
        }
    }
    
    // For Twitter
    if (self.switchTwitter.on) {
        
    }
    
    //[self skipClicked:nil];
}

-(void)postOnFacebook {
    if (![self.photo1 isEqualToString:@""]) {
        [self makeRequestToUpdateStatus:self.tvFacebook.text title:nil description:nil image:self.photo1 link:nil];
    }
}

- (void)makeRequestToUpdateStatus:(NSString *)message title:(NSString *)title description:(NSString *)description image:(NSString *)image link:(NSString *)link {
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   message, @"message",
                                   image, @"picture",
                                   nil];
    
    // Make the request
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  //NSLog(@"result: %@", result);
                                  //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Shared on facebook." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                  //[alert show];
                              } else {
                                  NSLog(@"%@", error.description);
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

@end
