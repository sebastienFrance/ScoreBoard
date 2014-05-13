//
//  ModelScorePlayer.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 29/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ModelPlayer, ModelScoreBoard, ModelScoreList;

@interface ModelScorePlayer : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * DisplayOrder;
@property (nonatomic, retain) ModelPlayer *Player;
@property (nonatomic, retain) ModelScoreBoard *ScoreBoard;
@property (nonatomic, retain) NSSet *ScoreList;
@end

@interface ModelScorePlayer (CoreDataGeneratedAccessors)

- (void)addScoreListObject:(ModelScoreList *)value;
- (void)removeScoreListObject:(ModelScoreList *)value;
- (void)addScoreList:(NSSet *)values;
- (void)removeScoreList:(NSSet *)values;
@end
