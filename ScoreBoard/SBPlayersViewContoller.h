//
//  PlayersTableViewContoller.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "ScoreBoardAppDelegate.h"

@class SBHistoryViewController;
@class ModelPlayer;
@class ModelScorePlayer;
@class ScoreBoardAppDelegate;
@class ModelScoreBoard;
@class ModelGameConfig;
@class SBPlayersCell;
@class MFMailComposeViewController;

@interface SBPlayersViewContoller : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate> {

}

@property (nonatomic) ModelScoreBoard *scoreBoardModel;
@property (nonatomic) ModelGameConfig *gameConfig;

@property (nonatomic, readonly) Boolean isGameStarted;


- (void) updateWithHistoricalGame:(ModelScoreBoard*) scoreBoardModel config:(ModelGameConfig*) gameConfig;
- (void) startNewGame;
- (void) startNewGameWithSamePlayer;
- (void) addPlayer:(ModelPlayer*) newPlayer;


- (void) endGameType;
- (void) updateScoreToPlayer;
- (void) cancelUpdateScoreToPlayer;



@end


