//
//  PlayersTableViewCellCustom.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelScorePlayer;

@interface PlayersTableViewCellCustom : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *playerNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *rankLabel;
@property (nonatomic, retain) IBOutlet UILabel *rankSharp;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *roundLabel;
@property (nonatomic, retain) IBOutlet UIImageView *photo;

- (void) initializeWith:(ModelScorePlayer*) argScorePlayer rank:(NSUInteger) theRank;

@end
