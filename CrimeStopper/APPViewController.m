//
//  APPViewController.m
//  PageApp
//
//  Created by Rafael Garcia Leiva on 10/06/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "APPViewController.h"
#import "APPChildViewController.h"
//#import "PageContentViewController.h"
#import "LoginVC.h"
#import "DisclaimerViewController.h"
#import "HomeScreenVC.h"
#import "HomePageVC.h"

@interface APPViewController ()

@end

@implementation APPViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     _pageImages = @[@"tour1.png", @"tour2.png", @"tour3.png", @"tour4.png", @"tour5.png",@"tour6.png"];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    
    NSLog(@"width : %f",self.view.frame.size.width);
    NSLog(@"width : %f",self.view.frame.size.height - 30);
    self.pageController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
   // self.pageController. = [UIColor blueColor];
    //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    APPChildViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    
    [self.pageController didMoveToParentViewController:self];
    self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:101.0/255.0f blue:179.0/255.0f alpha:1];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (NSInteger)getCount{
    
   _pageImages = @[@"tour1.png", @"tour6.png", @"tour5.png", @"tour2.png", @"tour3.png",@"tour4.png"];
    return self.pageImages.count;
    
}
- (APPChildViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageImages count] == 0) || (index >= [self.pageImages count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    APPChildViewController *pageContentViewController = [[APPChildViewController alloc]init];
    pageContentViewController.imageFile = self.pageImages[index];
   // pageContentViewController.delegate = self;
    pageContentViewController.pageIndex = index;
    
    
    
    return pageContentViewController;
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController pageIndex];
    
    if ((index == 0) || (index == NSNotFound)) {
        [self.btnSkip setTitle:@"Skip" forState:UIControlStateNormal];
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((APPChildViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        [self.btnSkip setTitle:@"Skip" forState:UIControlStateNormal];
        return nil;
    }
    
    index++;
    if (index == [self.pageImages count]) {
        [self.btnSkip setTitle:@"Done" forState:UIControlStateNormal];
        return nil;
    }
    return [self viewControllerAtIndex:index];
    
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageImages count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

- (IBAction)btnSkipClick:(id)sender {
    
//    LoginVC *vc = [[LoginVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
    //NSLog(@"second time... ");
    NSString *UserID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserID"];
    //NSLog(@"str : %@",UserID);
    if(UserID == nil || UserID == (id)[NSNull null])
    {
        DisclaimerViewController *vc = [[DisclaimerViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        HomePageVC *vc = [[HomePageVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }

   
    
}

- (void)changeStatus{
    if(self.pageImages.count == 6)
    {
         [self.btnSkip setTitle:@"Done" forState:UIControlStateNormal];
    }
//    if ([self.btnSkip.currentTitle isEqualToString:@"Done"]) {
//        
//        [self.btnSkip setTitle:@"Skip" forState:UIControlStateNormal];
//        
//    }else{
//        
//        [self.btnSkip setTitle:@"Done" forState:UIControlStateNormal];
//        
//    }
}
//- (APPChildViewController *)viewControllerAtIndex:(NSUInteger)index {
//    
//    APPChildViewController *childViewController = [[APPChildViewController alloc] initWithNibName:@"APPChildViewController" bundle:nil];
//    childViewController.index = index;
//    
//    return childViewController;
//    
//}

@end
