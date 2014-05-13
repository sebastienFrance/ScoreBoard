//
//  PlayersTableViewContoller.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <iAd/ADBannerView.h>
#import "ScoreBoardAppDelegate.h"
#import "ScoreLogViewController.h"

@class HistoryTableViewController;
@class ModelPlayer;
@class ModelScorePlayer;
@class ScoreBoardAppDelegate;
@class ModelScoreBoard;
@class ModelGameConfig;
@class PlayersTableViewCellCustom;
@class MFMailComposeViewController;

@interface PlayersTableViewContoller : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UINavigationBarDelegate, ADBannerViewContainer> {
    
}

@property (nonatomic) ScoreLogViewController* scoreBoard;
@property (nonatomic) ModelScoreBoard *scoreBoardModel;
@property (nonatomic) ModelGameConfig *gameConfig;

@property (nonatomic) NSMutableArray* modelScorePlayerList;

- (id)init;

- (void) addPlayer:(ModelPlayer*) newPlayer;


- (void) endGameType;
- (void) updateScoreToPlayer;
- (void) cancelUpdateScoreToPlayer;

@end


