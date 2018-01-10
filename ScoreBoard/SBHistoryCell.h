//
//  HistoryGameCellCustom.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 16/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModelScoreBoard;

@interface SBHistoryCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel* gameNameLabel;
@property (nonatomic, retain) IBOutlet UILabel* gameDateLabel;

- (void) initCellWithPlayer:(ModelScoreBoard*) argPlayer;

@end
