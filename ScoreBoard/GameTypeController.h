//
//  GameTypeController.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 09/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PlayersTableViewContoller;
@class ModelGameConfig;

@interface GameTypeController : UITableViewController

@property(nonatomic, retain) PlayersTableViewContoller *delegate;
@property(nonatomic, retain) ModelGameConfig *gameConfig;


@end
