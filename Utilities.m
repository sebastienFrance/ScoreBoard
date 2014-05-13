//
//  Utilities.m
//  ScoreLog
//
//  Created by sébastien brugalières on 25/01/2014.
//
//

#import "Utilities.h"
#import "ModelScorePlayer.h"

@implementation Utilities

+ (NSInteger) computePlayerRank:(ModelScorePlayer*) argScorePlayer scorePlayerList:(NSArray*) modelScorePlayerList isHigherScoreWin:(Boolean) highestScoreWin  {
    NSInteger rank = 1;
    NSMutableSet* scoreSet = [NSMutableSet setWithCapacity:modelScorePlayerList.count];
    NSNumber* scoreObject = Nil;
    for (int i =0; i < modelScorePlayerList.count; i++) {
        ModelScorePlayer* player = (ModelScorePlayer*) [modelScorePlayerList objectAtIndex:i];
        
        // avoid to count the same score twice
        scoreObject = [NSNumber numberWithInteger:player.totalScore];
        if ([scoreSet containsObject:scoreObject] == FALSE) {
            
            [scoreSet addObject:scoreObject];
            
            if (player != argScorePlayer) {
                if (highestScoreWin) {
                    if (player.totalScore > argScorePlayer.totalScore) {
                        rank++;
                    }
                } else {
                    if (player.totalScore < argScorePlayer.totalScore) {
                        rank++;
                    }
                }
            }
        }
    }
    
    return rank;
}


@end
