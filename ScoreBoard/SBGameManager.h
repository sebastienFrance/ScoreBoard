//
//  GameManager.h
//  ScoreLog
//
//  Created by sébastien brugalières on 30/09/2014.
//
//

#import <Foundation/Foundation.h>

@class SBPlayersViewContoller;

@interface SBGameManager : NSObject

+(SBGameManager*)sharedInstance;

@property(nonatomic) SBPlayersViewContoller* playerController;

@end
