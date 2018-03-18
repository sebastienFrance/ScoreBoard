//
//  SBHistoryCell.h
//  Score Log
//
//  Created by Sébastien Brugalières on 11/03/2018.
//

#import <UIKit/UIKit.h>

@class ModelScoreBoard;

@interface SBHistoryCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel* gameNameLabel;
@property (nonatomic, retain) IBOutlet UILabel* gameDateLabel;

- (void) initCellWithPlayer:(ModelScoreBoard*) argPlayer isOngoingGame:(BOOL) isOngoingGame;

@end

