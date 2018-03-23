//
//  ScoreHistoryTableViewCell.h
//  Score Log
//
//  Created by Sébastien Brugalières on 23/03/2018.
//

#import <UIKit/UIKit.h>

@interface ScoreHistoryTableViewCell : UITableViewCell

- (void) initCellWithScoreHistory:(NSUInteger) index value:(NSInteger) score lowest:(NSInteger) lowestScore highest:(NSInteger) highestScore;

@end
