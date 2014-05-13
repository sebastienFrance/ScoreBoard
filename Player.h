//
//  Player.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 24/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Player : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) id picture;
@property (nonatomic, retain) NSSet *ScorePlayer;
@end

@interface Player (CoreDataGeneratedAccessors)

- (void)addScorePlayerObject:(NSManagedObject *)value;
- (void)removeScorePlayerObject:(NSManagedObject *)value;
- (void)addScorePlayer:(NSSet *)values;
- (void)removeScorePlayer:(NSSet *)values;
@end
