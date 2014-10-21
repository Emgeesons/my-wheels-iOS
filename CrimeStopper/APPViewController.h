//
//  APPViewController.h
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPChildViewController.h"

@interface APPViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate,PageContentProtocol>

@property (strong, nonatomic) IBOutlet UIPageViewController *pageController;

@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (strong, nonatomic) NSArray *pageImages;

- (IBAction)btnSkipClick:(id)sender;
-(NSInteger)getCount;

@end
