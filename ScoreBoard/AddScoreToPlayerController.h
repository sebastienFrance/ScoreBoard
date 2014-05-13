//
//  AddScoreToPlayer.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayersTableViewContoller.h"

@class ModelScorePlayer;
@class ModelGameConfig;


@interface AddScoreToPlayerController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property(nonatomic) PlayersTableViewContoller *delegate;
@property(nonatomic) ModelScorePlayer *scorePlayer;
@property(nonatomic) NSMutableArray* modelScoreList;
@property(nonatomic) ModelGameConfig* gameConfig;

@end
