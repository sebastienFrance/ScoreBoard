//
//  ScoreHistoryTableViewCell.m
//  Score Log
//
//  Created by Sébastien Brugalières on 23/03/2018.
//

#import "ScoreHistoryTableViewCell.h"

@interface ScoreHistoryTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *theScoreLabel;

@end

@implementation ScoreHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initCellWithScoreHistory:(NSUInteger) index value:(NSInteger) score lowest:(NSInteger) lowestScore highest:(NSInteger) highestScore {
    
    self.theScoreLabel.text = [NSString stringWithFormat:@"%lu -> %ld", index + 1,(long)score];
    
    if (lowestScore == score) {
        self.theScoreLabel.textColor = [UIColor redColor];
    } else {
        if (highestScore == score) {
            self.theScoreLabel.textColor = [UIColor colorWithRed:0.15 green:0.64 blue:0.08 alpha:1.0];
        } else {
            self.theScoreLabel.textColor = [UIColor blackColor];
        }
    }
}

@end
