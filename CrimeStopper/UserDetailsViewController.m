//
//  Copyright (c) 2013 Parse. All rights reserved.

#import "UserDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WebApiController.h"
#import "SVProgressHUD.h"
#import "HomePageVC.h"
#import "LoginWithFacebookVC.h"

@implementation UserDetailsViewController
{
    AppDelegate *appdelegate;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.navigationController.navigationBarHidden = YES;
//    self.title = @"Facebook Profile";
//    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
//    
//    // Add logout navigation bar button
//    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStyleBordered target:self action:@selector(logoutButtonTouchHandler:)];
//    self.navigationItem.leftBarButtonItem = logoutButton;
//    
//    // Load table header view from nib
//    [[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil];
//    self.tableView.tableHeaderView = self.headerView;
//    
    // Create array for table row titles
    self.rowTitleArray = @[@"Location", @"Gender", @"Date of Birth", @"Relationship"];
    
    // Set default values for the table row data
    self.rowDataArray = [@[@"N/A", @"N/A", @"N/A", @"N/A"] mutableCopy];
    
    // If the user is already logged in, display any previously cached values before we get the latest from Facebook.
    if ([PFUser currentUser]) {
        [self updateProfile];
    }
    
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSLog(@"facebookID :: %@",facebookID);
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            
            if (facebookID) {
                userProfile[@"facebookId"] = facebookID;
            }
            
            if (userData[@"name"]) {
                userProfile[@"name"] = userData[@"name"];
            }
            
            if (userData[@"location"][@"name"]) {
                userProfile[@"location"] = userData[@"location"][@"name"];
            }
            
            if (userData[@"gender"]) {
                userProfile[@"gender"] = userData[@"gender"];
            }
            
            if (userData[@"birthday"]) {
                userProfile[@"birthday"] = userData[@"birthday"];
            }
            
            if (userData[@"relationship_status"]) {
                userProfile[@"relationship"] = userData[@"relationship_status"];
            }
            
            if ([pictureURL absoluteString]) {
                userProfile[@"pictureURL"] = [pictureURL absoluteString];
            }
            
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            
            [self updateProfile];
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [self logoutButtonTouchHandler:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    
}


#pragma mark - NSURLConnectionDataDelegate

/* Callback delegate methods used for downloading the user's profile picture */

//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    // As chuncks of the image are received, we build our data file
//    [self.imageData appendData:data];
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    // All data has been downloaded, now we can set the image in the header image view
//    self.headerImageView.image = [UIImage imageWithData:self.imageData];
//    
//    // Add a nice corner radius to the image
//    self.headerImageView.layer.cornerRadius = 8.0f;
//    self.headerImageView.layer.masksToBounds = YES;
//}


//#pragma mark - UITableViewDataSource
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    // Return the number of rows in the section.
//    return self.rowTitleArray.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        // Create the cell and add the labels
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 120.0f, 44.0f)];
//        titleLabel.tag = 1; // We use the tag to set it later
//        titleLabel.textAlignment = NSTextAlignmentRight;
//        titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
//        titleLabel.backgroundColor = [UIColor clearColor];
//        
//        UILabel *dataLabel = [[UILabel alloc] initWithFrame:CGRectMake( 130.0f, 0.0f, 165.0f, 44.0f)];
//        dataLabel.tag = 2; // We use the tag to set it later
//        dataLabel.font = [UIFont systemFontOfSize:15.0f];
//        dataLabel.backgroundColor = [UIColor clearColor];
//        
//        [cell.contentView addSubview:titleLabel];
//        [cell.contentView addSubview:dataLabel];
//    }
//    
//    // Cannot select these cells
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    // Access labels in the cell using the tag #
//    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
//    UILabel *dataLabel = (UILabel *)[cell viewWithTag:2];
//    
//    // Display the data in the table
//    titleLabel.text = [self.rowTitleArray objectAtIndex:indexPath.row];
//    dataLabel.text = [self.rowDataArray objectAtIndex:indexPath.row];
//    
//    return cell;
//}
//

#pragma mark - ()

- (void)logoutButtonTouchHandler:(id)sender {
    // Logout user, this automatically clears the cache
    [PFUser logOut];
    
    // Return to login view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Set received values if they are not nil and reload the table
- (void)updateProfile {
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"gender"]) {
        [self.rowDataArray replaceObjectAtIndex:1 withObject:[[PFUser currentUser] objectForKey:@"profile"][@"gender"]];
        appdelegate.strGender = [[PFUser currentUser] objectForKey:@"profile"][@"gender"];
        NSLog(@"app gender :: %@",appdelegate.strGender);
    }
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"birthday"]) {
        [self.rowDataArray replaceObjectAtIndex:2 withObject:[[PFUser currentUser] objectForKey:@"profile"][@"birthday"]];
        appdelegate.strFBdob =[[PFUser currentUser] objectForKey:@"profile"][@"birthday"];
        NSLog(@"app dob :%@",appdelegate.strFBdob);
    }
    
//       [self.tableView reloadData];
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"facebookId"]) {
        [self.rowDataArray replaceObjectAtIndex:2 withObject:[[PFUser currentUser] objectForKey:@"profile"][@"facebookId"]];
        appdelegate.strFacebookID =[[PFUser currentUser] objectForKey:@"profile"][@"facebookId"];
        NSLog(@"app facebook id :%@",appdelegate.strFacebookID);
    }
    
    if ([[PFUser currentUser] objectForKey:@"public_profile"][@"email"]) {
        [self.rowDataArray replaceObjectAtIndex:2 withObject:[[PFUser currentUser] objectForKey:@"profile"][@"email"]];
        appdelegate.strFacebookEmail =[[PFUser currentUser] objectForKey:@"profile"][@"email"];
        NSLog(@"app facebook email :%@",appdelegate.strFacebookEmail);
    }

    appdelegate.strFacebookToken =[[[FBSession activeSession] accessTokenData] accessToken];
    NSLog(@"app facebook Token :%@",appdelegate.strFacebookToken);
    
    
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
            if (!error) {
              
                appdelegate.strFacebookEmail = [user objectForKey:@"email"];
                NSLog(@"email : %@",appdelegate.strFacebookEmail);
            }
        }];
    }
    // Set the name in the header view label
    if ([[PFUser currentUser] objectForKey:@"profile"][@"name"]) {
       
        appdelegate.strFBUserName = [[PFUser currentUser] objectForKey:@"profile"][@"name"];
        NSLog(@"app username : %@",appdelegate.strFBUserName);
        
        
    }
    
    // Download the user's facebook profile picture
  // the data will be loaded in here
    
    if ([[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]) {
        NSURL *pictureURL = [NSURL URLWithString:[[PFUser currentUser] objectForKey:@"profile"][@"pictureURL"]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:2.0f];
        // Run network request asynchronously
        /*email
         firstName
         lastName
         dob
         gender
         fbId
         fbToken
         os
         make
         model
*/
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-mm-dd"];
        NSLog(@"date:: %@",appdelegate.strFBdob);
        NSDate *date = [dateFormatter dateFromString:appdelegate.strFBdob];
        NSLog(@"date :: %@",date);
         NSString *birthDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
        NSLog(@"birth date: %@",birthDate);
        NSArray * arr = [appdelegate.strFBUserName componentsSeparatedByString:@" "];
        NSLog(@"Array values are : %@",arr);
        
        WebApiController *obj=[[WebApiController alloc]init];
        NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
        [param setValue:@"asha@emgeesons.com" forKey:@"email"];
        [param setValue:[arr objectAtIndex:0] forKey:@"firstName"];
        [param setValue:[arr objectAtIndex:1] forKey:@"lastName"];
        [param setValue:@"1989-09-14" forKey:@"dob"];
        [param setValue:appdelegate.strGender forKey:@"gender"];
        [param setValue:appdelegate.strFacebookID forKey:@"fbId"];
        [param setValue:appdelegate.strFacebookToken forKey:@"fbToken"];
        [param setValue:@"iOS7" forKey:@"os"];
        [param setValue:@"iPhone" forKey:@"make"];
        [param setValue:@"iPhone5,iPhone5S" forKey:@"model"];
        [obj callAPI_POST:@"fbLoginRegister.php" andParams:param SuccessCallback:@selector(service_reponse:Response:) andDelegate:self];
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        
//        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
//        if (!urlConnection) {
//            NSLog(@"Failed to download picture");
//        }
    }
}
-(void)service_reponse:(NSString *)apiAlias Response:(NSData *)response
{
    NSMutableArray *jsonDictionary=[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"Json dictionary :: %@",jsonDictionary);
    NSString *EntityID = [jsonDictionary valueForKey:@"status"];
    NSLog(@"message %@",EntityID);
    if ([EntityID isEqualToString:@"failure"])
    {
        UIAlertView *CheckAlert = [[UIAlertView alloc]initWithTitle:@"Warning"
                                                            message:[jsonDictionary valueForKey:@"message"]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [CheckAlert show];
       
    }
    else
    {
      if([[jsonDictionary valueForKey:@"message"] isEqualToString:@"Existing User"])
      {
          HomePageVC *vc = [[HomePageVC alloc]init];
          [self presentViewController:vc animated:YES completion:nil];
      }
      else if([[jsonDictionary valueForKey:@"message"] isEqualToString:@"New User"])
      {
          LoginWithFacebookVC *vc = [[LoginWithFacebookVC alloc]init];
          [self presentViewController:vc animated:YES completion:nil];
      }
      else if([[jsonDictionary valueForKey:@"message"] isEqualToString:@"Complete Profile"])
      {
          appdelegate.strUserID = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"user_id"];;
          appdelegate.strOldPin = [[[jsonDictionary valueForKey:@"response"] objectAtIndex:0] valueForKey:@"pin"];;
          NSLog(@"user id :%@",appdelegate.strUserID);
          NSLog(@"pin :%@",appdelegate.strOldPin);
          LoginWithFacebookVC *vc = [[LoginWithFacebookVC alloc]init];
          [self presentViewController:vc animated:YES completion:nil];
      }
      else
      {
          
      }
    }
   
    [SVProgressHUD dismiss];
}

@end
