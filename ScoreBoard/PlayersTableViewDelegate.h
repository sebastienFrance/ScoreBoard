//
//  PlayersTableViewDelegate.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 11/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ScorePlayer.h"
#import "PlayersTableViewContoller.h"

@interface PlayersTableViewDelegate : NSObject {
    IBOutlet PlayersTableViewContoller *playerTableViewController;
    IBOutlet UINavigationController *navigationController;
}

@end
