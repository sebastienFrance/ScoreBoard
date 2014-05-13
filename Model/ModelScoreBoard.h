//
//  ModelScoreBoard.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 08/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ModelGameConfig, ModelScorePlayer;

@interface ModelScoreBoard : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * GameDate;
@property (nonatomic, retain) NSString * GameName;
@property (nonatomic, retain) ModelGameConfig *GameConfig;
@property (nonatomic, retain) NSSet *ScoreList;
@end

@interface ModelScoreBoard (CoreDataGeneratedAccessors)

- (void)addScoreListObject:(ModelScorePlayer *)value;
- (void)removeScoreListObject:(ModelScorePlayer *)value;
- (void)addScoreList:(NSSet *)values;
- (void)removeScoreList:(NSSet *)values;
@end
