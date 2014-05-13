//
//  GameTypeController.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 09/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameTypeController.h"
#import "PlayersTableViewContoller.h"
#import "ModelGameConfig.h"
#import "DatabaseAccess.h"
#import "ModelScoreBoard.h"
#import "ScoreBoardAboutController.h"

@interface GameTypeController()

@property (nonatomic, retain) IBOutlet UISwitch *negativeScoreSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *bestScorceWinSwitch;
@property (nonatomic, retain) IBOutlet UITextField *gameNameTextField;

@end


@implementation GameTypeController

- (void)viewDidLoad
{
    self.navigationItem.title = NSLocalizedString(@"Game Options", @"(GameTypeController) Title of view to configure game options");
    
    self.negativeScoreSwitch.on = [self.gameConfig.NegativeScore boolValue];
    self.bestScorceWinSwitch.on = [self.gameConfig.HighestScoreWin boolValue];
    self.gameNameTextField.text = self.delegate.scoreBoardModel.GameName;
    
    [super viewDidLoad];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveAll];
}

- (void)saveAll {

    self.gameConfig.HighestScoreWin = [NSNumber numberWithBool:self.bestScorceWinSwitch.on];
    self.gameConfig.NegativeScore = [NSNumber numberWithBool:self.negativeScoreSwitch.on];
    self.delegate.scoreBoardModel.GameName = self.gameNameTextField.text;
    
    // Update the Game config and ScoreBoardModel in core data
    NSManagedObjectContext* context = [[DatabaseAccess sharedManager] managedObjectContext];
    NSError *error = nil;
    if (![context save:&error]) {
        // Handle the error.
        NSLog(@"GameTypeController::doneButtonCalled -> Save ERROR");
    }
 	
    [self.delegate endGameType];
}



@end
