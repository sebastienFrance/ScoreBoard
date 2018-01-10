//
//  GameTypeController.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 09/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SBGameTypeViewController.h"
#import "SBPlayersViewContoller.h"
#import "ModelGameConfig.h"
#import "DatabaseAccess.h"
#import "ModelScoreBoard.h"
#import "SBAboutViewController.h"
#import "SWRevealViewController.h"
#import "SBGameManager.h"

@interface SBGameTypeViewController()

@property (nonatomic, retain) IBOutlet UISwitch *negativeScoreSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *bestScorceWinSwitch;
@property (nonatomic, retain) IBOutlet UITextField *gameNameTextField;

@end


@implementation SBGameTypeViewController

- (void)viewDidLoad
{
    ModelGameConfig *gameConfig = [SBGameManager sharedInstance].playerController.gameConfig;
    
    self.navigationItem.title = NSLocalizedString(@"Game Options", @"(GameTypeController) Title of view to configure game options");
    
    self.negativeScoreSwitch.on = [gameConfig.NegativeScore boolValue];
    self.bestScorceWinSwitch.on = [gameConfig.HighestScoreWin boolValue];
    self.gameNameTextField.text = [SBGameManager sharedInstance].playerController.scoreBoardModel.GameName;
    
    [super viewDidLoad];
}

- (IBAction)menuButtonPushed:(UIBarButtonItem *)sender {
    [self.revealViewController revealToggle:Nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveAll];
}

- (void)saveAll {

    ModelGameConfig *gameConfig = [SBGameManager sharedInstance].playerController.gameConfig;

    
    gameConfig.HighestScoreWin = [NSNumber numberWithBool:self.bestScorceWinSwitch.on];
    gameConfig.NegativeScore = [NSNumber numberWithBool:self.negativeScoreSwitch.on];
    [SBGameManager sharedInstance].playerController.scoreBoardModel.GameName = self.gameNameTextField.text;
    
    // Update the Game config and ScoreBoardModel in core data
    NSManagedObjectContext* context = [[DatabaseAccess sharedManager] managedObjectContext];
    NSError *error = nil;
    if (![context save:&error]) {
        // Handle the error.
        NSLog(@"GameTypeController::doneButtonCalled -> Save ERROR");
    }
 	
    [[SBGameManager sharedInstance].playerController endGameType];
}



@end
