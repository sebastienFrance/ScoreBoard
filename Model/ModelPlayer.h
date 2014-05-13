//
//  ModelPlayer.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 25/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ModelScorePlayer;

@interface ModelPlayer : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) id picture;
@property (nonatomic, retain) NSSet *ScorePlayer;
@end

@interface ModelPlayer (CoreDataGeneratedAccessors)

- (void)addScorePlayerObject:(ModelScorePlayer *)value;
- (void)removeScorePlayerObject:(ModelScorePlayer *)value;
- (void)addScorePlayer:(NSSet *)values;
- (void)removeScorePlayer:(NSSet *)values;
@end
