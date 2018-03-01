//
//  ScoreBoardAppDelegate.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 09/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@class ModelScoreBoard;

@interface ScoreBoardAppDelegate : NSObject <UIApplicationDelegate >

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) UIViewController* currentViewController;

@end
