//
//  ModelScorePlayer.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 29/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ModelScorePlayer.h"
#import "ModelPlayer.h"
#import "ModelScoreBoard.h"
#import "ModelScoreList.h"


@implementation ModelScorePlayer
@dynamic DisplayOrder;
@dynamic Player;
@dynamic ScoreBoard;
@dynamic ScoreList;
@synthesize totalScore;

- (id) init {
    self = [super init];
    [self refreshScore];
    return self;
}

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    [self refreshScore];
    return self;
    
}

- (void) refreshScore {
    NSEnumerator* enumerator = [self.ScoreList objectEnumerator];
    ModelScoreList *score = Nil;
    totalScore = 0;
    while ((score = [enumerator nextObject]) != Nil) {
        totalScore += [[score Score] integerValue];
    }
}

@end
