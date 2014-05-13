//
//  ScoreBoardAppDelegate.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 09/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <iAd/ADBannerView.h>

@protocol ADBannerViewContainer <NSObject>

- (void) hideBanner:(ADBannerView*) adBanner;
- (void) showBanner:(ADBannerView*) adBanner;

@optional
- (BOOL) bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave;
- (void) bannerViewActionDidFinish:(ADBannerView *)banner;


@end

@class ModelScoreBoard;

@interface ScoreBoardAppDelegate : NSObject <UIApplicationDelegate, ADBannerViewDelegate >

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) ADBannerView* adBanner;
@property (nonatomic, retain) UIViewController<ADBannerViewContainer>* currentViewController;

@end
