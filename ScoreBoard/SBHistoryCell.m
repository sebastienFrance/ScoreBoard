//
//  SBHistoryCell.m
//  Score Log
//
//  Created by Sébastien Brugalières on 11/03/2018.
//

#import "SBHistoryCell.h"
#import "ModelScoreBoard.h"

@implementation SBHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) initCellWithPlayer:(ModelScoreBoard*) argPlayer {
    
    NSDate* currentDate = [argPlayer GameDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString* stringDate = [dateFormatter stringFromDate:currentDate];
    
    self.gameDateLabel.text = stringDate;
    self.gameNameLabel.text = argPlayer.GameName;
}


@end

