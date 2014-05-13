//
//  ScoreBoardAppDelegate.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 09/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreBoardAppDelegate.h"
#import "ModelScoreBoard.h"
#import "DatabaseAccess.h"
#import "PlayersTableViewContoller.h"
#import "HistoryTableViewController.h"

@implementation ScoreBoardAppDelegate

@synthesize adBanner;
@synthesize currentViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Customize the status bar 
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationFade];    

    // Create ADBannerView
    [self createBannerView];
    
    return YES;
}

// Create the ADBannerView that will be used in other viewController
// Only one ADBannerView must be created per application
- (void)createBannerView {
  
    
    adBanner = [[ADBannerView alloc] initWithFrame:CGRectZero];
    self.adBanner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    self.adBanner.delegate = self;

    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect bannerFrame = self.adBanner.frame;
    bannerFrame.origin = CGPointMake(CGRectGetMinX(screenBounds), CGRectGetMaxY(screenBounds));
    self.adBanner.frame = bannerFrame;
}



// To be completed -----------------
- (void)applicationWillResignActive:(UIApplication *)application
{
}

// To be completed -----------------
- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

// To be completed -----------------
- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

// To be completed -----------------
- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

// To be completed -----------------
- (void)applicationWillTerminate:(UIApplication *)application
{
}

// ---------- Implementation of ADBannerViewDelegate

- (void)bannerViewWillLoadAd:(ADBannerView *)banner {
}

// An Ad is available, it should be displayed in the view if the view is available
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	
    if (currentViewController != Nil) {
        [currentViewController showBanner:banner];
    }
}

// Manage the error Message about the ADBannerView
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	switch (error.code) {
        case ADErrorApplicationInactive:
            NSLog(@"ADErrorApplicationInactive");
            break;
        case ADErrorBannerVisibleWithoutContent:
            NSLog(@"ADErrorBannerVisibleWithoutContent");
            break;
        case ADErrorConfigurationError:
            NSLog(@"ADErrorConfigurationError");
            break;
        case ADErrorInventoryUnavailable:
            NSLog(@"ADErrorInventoryUnavailable");
            break;
        case ADErrorLoadingThrottled:
            NSLog(@"ADErrorLoadingThrottled");
            break;
        case ADErrorServerFailure:
            NSLog(@"ADErrorServerFailure");
            break;
        case ADErrorUnknown:
            NSLog(@"ADErrorUnknown");
            break;
    }
    if (currentViewController != Nil) {
        [currentViewController hideBanner:banner];
    }
}

// Stop all users interaction while the banner action is running
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    // Nothing need to be stopped for Score Board
    if (currentViewController != Nil) {
        if ([currentViewController respondsToSelector:@selector(bannerViewActionShouldBegin:willLeaveApplication:)]) {
            return [currentViewController bannerViewActionShouldBegin:banner willLeaveApplication:willLeave];           
        }
    } 
    return TRUE;   
}

// This method should resume the activities from the application
- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    if (currentViewController != Nil) {
        if ([currentViewController respondsToSelector:@selector(bannerViewActionDidFinish:)]) {
        [currentViewController bannerViewActionDidFinish:banner];
        }
    }
}

@end
