//
//  Utilities.h
//  ScoreLog
//
//  Created by sébastien brugalières on 25/01/2014.
//
//

#import <Foundation/Foundation.h>

@class  ModelScorePlayer;

@interface Utilities : NSObject


+ (NSInteger) computePlayerRank:(ModelScorePlayer*) argScorePlayer scorePlayerList:(NSArray*) modelScorePlayerList isHigherScoreWin:(Boolean) highestScoreWin;

@end
