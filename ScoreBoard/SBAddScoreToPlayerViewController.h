//
//  AddScoreToPlayer.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPlayersViewContoller.h"

@class ModelScorePlayer;
@class ModelGameConfig;


@interface SBAddScoreToPlayerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>

@property(nonatomic) ModelScorePlayer *scorePlayer;
@property(nonatomic) NSMutableArray* modelScoreList;

@end
