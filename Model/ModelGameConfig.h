//
//  ModelGameConfig.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 09/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ModelScoreBoard;

@interface ModelGameConfig : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * NegativeScore;
@property (nonatomic, retain) NSNumber * OrderBy;
@property (nonatomic, retain) NSNumber * HighestScoreWin;
@property (nonatomic, retain) ModelScoreBoard *ScoreBoard;

@end
