//
//  PlayersTableViewCellCustom.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayersTableViewCellCustom.h"
#import "ModelScorePlayer.h"
#import "ModelPlayer.h"

@implementation PlayersTableViewCellCustom

@synthesize photo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

//- (void)willTransitionToState:(UITableViewCellStateMask)state {
//    [super willTransitionToState:state];
//    if ((state == UITableViewCellStateShowingDeleteConfirmationMask) || (state == UITableViewCellStateShowingEditControlMask)) {
//        [UIView animateWithDuration:0.5
//                         animations:^{self.rankLabel.alpha = 0.0;self.rankSharp.alpha = 0.0;}];
//    }
//}
//
//- (void)didTransitionToState:(UITableViewCellStateMask)state {
//    [super didTransitionToState:state];
//    if (state == UITableViewCellStateDefaultMask) {
//        [UIView animateWithDuration:0.5
//                         animations:^{self.rankLabel.alpha = 1.0;self.rankSharp.alpha = 1.0;}];
//    } 
//}


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
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", argScorePlayer.totalScore];
    self.scoreLabel.textColor = [UIColor blueColor];
    
    self.roundLabel.text = [NSString stringWithFormat:@"%d", scoreList.count];
    self.roundLabel.textColor = [UIColor blueColor];
    
    
    self.rankLabel.text = [NSString stringWithFormat:@"%d", theRank];
}


@end
