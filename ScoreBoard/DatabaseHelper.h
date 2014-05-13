//
//  DatabaseHelper.h
//  ScoreLog
//
//  Created by sébastien brugalières on 24/01/2014.
//
//

#import <Foundation/Foundation.h>

@class ModelPlayer;
@class ModelScoreBoard;
@class ModelScorePlayer;
@class ModelScoreList;

@interface DatabaseHelper : NSObject


+ (NSArray*) loadHistory;
+ (ModelPlayer*) addPlayer:(NSString*) lastName picture:(UIImage*) thePicture email:(NSString*) theEmail;

+ (ModelScoreBoard*) addModelScoreBoard;

+ (ModelScorePlayer*) addModelScorePlayer:(ModelPlayer *) newPlayer scoreBoardModel:(ModelScoreBoard*) theScoreBoardModel;
+(NSMutableArray*) getSortedScoreList:(ModelScorePlayer*) scorePlayer;
+(void) addScoreTo:(ModelScorePlayer*) player score:(NSUInteger) NewScore;
+(void) deleteScoreFrom:(NSMutableArray*) modelScoreList index:(NSUInteger) row;
+(void) deleteScoreBoard:(ModelScoreBoard*) scoreBoardModel;
+(NSMutableArray*) reorderPlayer:(NSMutableArray*) modelScorePlayerList highestScoreWin:(Boolean) isHighestScoreWin;
+(ModelScoreBoard *) duplicateGame:(ModelScoreBoard*) modelGame;
+(void) deleteScorePlayerAndReorder:(NSMutableArray*) modelScorePlayerList atRow:(NSUInteger) row;
+(NSMutableArray*) loadScorePlayerList:(ModelScoreBoard*) scoreBoardModel;
@end
