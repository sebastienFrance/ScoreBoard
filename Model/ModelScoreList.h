//
//  ModelScoreList.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 30/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ModelScorePlayer;

@interface ModelScoreList : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * Index;
@property (nonatomic, retain) NSNumber * Score;
@property (nonatomic, retain) NSNumber * DisplayOrder;
@property (nonatomic, retain) ModelScorePlayer *ScorePlayer;

@end
