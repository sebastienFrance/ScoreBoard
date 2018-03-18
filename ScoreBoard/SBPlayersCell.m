//
//  PlayersTableViewCellCustom.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SBPlayersCell.h"
#import "ModelScorePlayer.h"
#import "ModelPlayer.h"

@implementation SBPlayersCell

@synthesize photo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


// Configure the cell for a Player. It computes also the player rank
- (void) initializeWith:(ModelScorePlayer*) argScorePlayer rank:(NSUInteger) theRank {
    
    ModelPlayer* player = argScorePlayer.Player;
    
    self.playerNameLabel.text = player.lastName;
    
    self.photo.image = [[argScorePlayer Player] picture];
    if (self.photo.image == Nil) {
        self.photo.image = [UIImage imageNamed:@"No_Photo.png"];
    } else {
        self.photo.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    NSSet* scoreList = [argScorePlayer ScoreList];
    
    // update the score
    self.scoreLabel.text = [NSString stringWithFormat:@"score: %ld", (long)argScorePlayer.totalScore];
    self.scoreLabel.textColor = [UIColor blueColor];
    
    self.roundLabel.text = [NSString stringWithFormat:NSLocalizedString(@"round: %lu", Nil), (unsigned long)scoreList.count];
    self.roundLabel.textColor = [UIColor blueColor];
    
    
    self.rankLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)theRank];
}


@end
