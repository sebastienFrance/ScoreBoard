//
//  SBActionsTableViewCell.m
//  Score Log
//
//  Created by Sébastien Brugalières on 13/03/2018.
//

#import "SBActionsTableViewCell.h"

@interface SBActionsTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *emptyGameButton;
@property (weak, nonatomic) IBOutlet UIButton *gameWithSamePlayersButton;
@end

@implementation SBActionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) initWithoutNewGameButton {
    self.emptyGameButton.hidden = true;
    self.gameWithSamePlayersButton.hidden = true;
}

- (void) initWithNewGameButton {
    self.emptyGameButton.hidden = false;
    self.gameWithSamePlayersButton.hidden = false;
}


@end
