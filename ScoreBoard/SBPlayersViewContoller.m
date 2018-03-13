//
//  PlayersTableViewContoller.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModelScorePlayer.h"
#import "SBPlayersViewContoller.h"
#import "SBAddPlayerViewController.h"
#import "SBAddScoreToPlayerViewController.h"
#import "ModelPlayer.h"
#import "ModelScoreList.h"
#import "ModelScoreBoard.h"
#import "ModelGameConfig.h"
#import "ScoreBoardAppDelegate.h"
#import "DatabaseAccess.h"
#import "SBPlayersCell.h"
#import "SBGameTypeViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <UIKit/UIScreen.h>
#import "DatabaseHelper.h"
#import "Utilities.h"
#import "MailHelper.h"
#import "SBGameManager.h"
#import "SBActionsTableViewCell.h"

@interface SBPlayersViewContoller()

@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mailButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *reorderPlayersButton;

@property (nonatomic) NSMutableArray<ModelScorePlayer*>* modelScorePlayerList;

@end

@implementation SBPlayersViewContoller

static NSUInteger const SECTION_PLAYERS = 0;
static NSUInteger const SECTION_ACTIONS = 1;

-(Boolean) isGameStarted {
    return self.gameConfig != Nil;
}

#pragma mark - View lifecycle


// Fetch the content of the current game (List of Players). It's ordered with the DisplayOrder field.
- (void)viewDidLoad
{
    [SBGameManager sharedInstance].playerController = self;
    
    self.tv.dataSource = self;
    self.tv.delegate = self;
    self.tv.rowHeight = UITableViewAutomaticDimension;
    self.tv.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
    
    [self initializeNewGame];
}

// Start a new game and cleanup the tableview
- (void) startNewGame {
    [self initializeNewGame];
    [self.tv reloadData];
}

-(void) initializeNewGame {
    self.modelScorePlayerList = [[NSMutableArray alloc] init];
    self.scoreBoardModel = Nil;
    self.gameConfig = Nil;
    [self refreshButtonState];
}

// Start a new game with the list of players from the current game
-(void) startNewGameWithSamePlayer {
    if (self.scoreBoardModel != Nil) {
        // Duplicate the list of players of the current game
        self.scoreBoardModel = [DatabaseHelper duplicateGame:self.scoreBoardModel];
        self.gameConfig = self.scoreBoardModel.GameConfig;
        
        self.modelScorePlayerList =[DatabaseHelper loadScorePlayerList:self.scoreBoardModel];
        
        // Cleanup the tableview content with the list of players
        NSIndexSet* sectionIndex = [NSIndexSet indexSetWithIndex:0];
        [self.tv reloadSections:sectionIndex withRowAnimation:UITableViewRowAnimationRight];
    }
}


- (void) updateWithHistoricalGame:(ModelScoreBoard*) scoreBoardModel config:(ModelGameConfig*) gameConfig {
    self.scoreBoardModel = scoreBoardModel;
    self.gameConfig = gameConfig;
    
    self.modelScorePlayerList =[DatabaseHelper loadScorePlayerList:self.scoreBoardModel];
    
    [self refreshButtonState];
    
    [self.tv reloadData];
}

#pragma mark - Utilities
-(void) refreshButtonState {
    if ((self.scoreBoardModel != Nil) && (self.scoreBoardModel.ScoreList.count > 0)) {
        self.mailButton.enabled = TRUE;
        if (self.scoreBoardModel.ScoreList.count > 1) {
            self.reorderPlayersButton.enabled = TRUE;
        } else {
            self.reorderPlayersButton.enabled = FALSE;
        }
    } else {
        self.mailButton.enabled = FALSE;
        self.reorderPlayersButton.enabled = FALSE;
    }
}



#pragma mark - Buttons callback

// Open a modal view to send a Mail with current results
- (IBAction)SendMail {
    MFMailComposeViewController *picker = [MailHelper prepareEmail:self scoreBoard:self.scoreBoardModel playerList:self.modelScorePlayerList];
    [self presentViewController:picker animated:YES completion:Nil];
}

- (IBAction) reorderPlayersTapped {
    
    NSMutableArray<ModelScorePlayer*> *sortedModelScorePlayer = [DatabaseHelper reorderPlayer:self.modelScorePlayerList
                                                           highestScoreWin:self.gameConfig.HighestScoreWin.boolValue];

    NSArray<NSIndexPath*>* visibleCells = [self.tv indexPathsForVisibleRows];
    NSMutableArray<NSIndexPath*>* cellsToBeRefreshed = [[NSMutableArray alloc] initWithCapacity:visibleCells.count];
    NSIndexPath* currIndex = Nil;
    ModelScorePlayer* currModelScorePlayer = Nil;
    ModelScorePlayer* currOrderdModelScorePlayer = Nil;
    
    for (NSUInteger i = 0; i < visibleCells.count; i++) {
        currIndex = [visibleCells objectAtIndex:i];
        if (currIndex.section != SECTION_PLAYERS) {
            continue;
        }
        
        currModelScorePlayer =  [self.modelScorePlayerList objectAtIndex:currIndex.row];
        currOrderdModelScorePlayer = [sortedModelScorePlayer objectAtIndex:currIndex.row];
        
        if (currModelScorePlayer != currOrderdModelScorePlayer) {
            [cellsToBeRefreshed addObject:currIndex];
        }
    }
    
    self.modelScorePlayerList = sortedModelScorePlayer;
 
    [self.tv beginUpdates];
    [self.tv deleteRowsAtIndexPaths:cellsToBeRefreshed withRowAnimation:UITableViewRowAnimationTop];
    [self.tv insertRowsAtIndexPaths:cellsToBeRefreshed withRowAnimation:UITableViewRowAnimationBottom];
    [self.tv endUpdates];
}

#pragma mark - MFMailComposeViewControllerDelegate protocol
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self  dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - Callback for delegate
// Method called when a new Player has been created by the AddPlayerController
// and close the modal view
- (void) addPlayer: (ModelPlayer*) newPlayer {

    if (self.scoreBoardModel == Nil) {
        self.scoreBoardModel = [DatabaseHelper addModelScoreBoard];
        self.gameConfig = self.scoreBoardModel.GameConfig;
    }
   
    [self showPlayer:newPlayer];
    
    if (self.modelScorePlayerList.count == 1) {
        // When we have at least one player we can display the buttons to create new empty game and duplicate game
        NSIndexSet* indexes = [[NSIndexSet alloc] initWithIndex:1];
        [self.tv reloadSections:indexes withRowAnimation:UITableViewRowAnimationNone];
    }
}


// Method called when the view to configure the game is closed
// Need to refresh the table view because the content can be displayed differently
- (void) endGameType {
    [self.tv reloadData];
}

// Called when the score has been changed for a player
// Need to refresh the table view because the content can be displayed differently
- (void) updateScoreToPlayer {
    [self.tv reloadData];
}

// Called when score modification has been canceled
// Need to refresh the table view because the content can be displayed differently
- (void) cancelUpdateScoreToPlayer {
    // Need to refresh the view in case the score history has been changed (row removed)
    [self.tv reloadData];
}

// Record the new player in the game and display in the table.
- (void)showPlayer:(ModelPlayer *) newPlayer {

    
    ModelScorePlayer *newScorePlayer = [DatabaseHelper addModelScorePlayer:newPlayer scoreBoardModel:self.scoreBoardModel];
    [self.modelScorePlayerList insertObject:newScorePlayer atIndex:[self.modelScorePlayerList count]];

    
    NSArray<NSIndexPath*> *insertIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:[self.modelScorePlayerList count]-1 inSection:0],
                                               nil];
    
    // need to refresh also the visible screen because maybe the game already started and we need to update the rank
    // for example if highestScore win == false then the new player with score = 0 could have a better rank than others players
    
    // need to get all visible cells and compare with the new player for the score.
    // Get Score from the cell to be removed to compute the cell for which the rank must be updated
    NSInteger newPlayerDefaultScore = 0;
    
    BOOL highestScoreWin = self.gameConfig.HighestScoreWin.boolValue;
    
    // Get the list of visible cells to build from this list the cells that must be refreshed
    NSArray<NSIndexPath*>* visibleCells = [self.tv indexPathsForVisibleRows];
    NSMutableArray<NSIndexPath*>* cellsTorefresh = [[NSMutableArray alloc] initWithCapacity:(visibleCells.count) ];
    
    for (NSUInteger i = 0 , j = 0; i < visibleCells.count; i++) {
        NSIndexPath* tempIndexPath = [visibleCells objectAtIndex:i];
        if (tempIndexPath.section != SECTION_PLAYERS) {
            continue;
        }
        
        SBPlayersCell* currentCell = (SBPlayersCell*) [self.tv cellForRowAtIndexPath:tempIndexPath];
        NSInteger currentScore = [currentCell.scoreLabel.text integerValue]; 
        if ((highestScoreWin && newPlayerDefaultScore > currentScore) || (!highestScoreWin && newPlayerDefaultScore < currentScore)) {
            [cellsTorefresh insertObject:tempIndexPath atIndex:j];
            j++;
        }
    }
        
    [self.tv beginUpdates];
    [self.tv reloadRowsAtIndexPaths:cellsTorefresh withRowAnimation:UITableViewRowAnimationNone];
    [self.tv insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationRight];
    [self.tv endUpdates];
}

- (IBAction)addNewPlayer:(UIButton *)sender {
    // It's a workaround to avoid latency when opening a Modal from a TableView in a Tabbar... see: https://stackoverflow.com/questions/26469268/delay-in-presenting-a-modal-view-controller
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"openAddPlayer" sender:Nil];
    });
}

- (IBAction)startNewEmptyGame:(UIButton *)sender {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Start new game"
                                                                   message:@"Do you want to start a new game?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* startNewGameAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {[self startNewGame];}];
    
    UIAlertAction* cancelNewGame = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:startNewGameAction];
    [alert addAction:cancelNewGame];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)startNewGameWithSamePlayers:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Duplicate game"
                                                                   message:@"Do you want to create a new game with the same players?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* startNewGameAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * action) {[self startNewGameWithSamePlayer];}];
    
    UIAlertAction* cancelNewGame = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:startNewGameAction];
    [alert addAction:cancelNewGame];
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark - UITableViewDataSource protocol


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == SECTION_PLAYERS ? self.scoreBoardModel.GameName : Nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// The number of rows is the number of players in the game
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SECTION_PLAYERS) {
        [self refreshButtonState];
        return self.modelScorePlayerList.count;
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if(section == 0 && [view isKindOfClass:[UITableViewHeaderFooterView class]]){
        UITableViewHeaderFooterView *tableViewHeaderFooterView = (UITableViewHeaderFooterView *) view;
        tableViewHeaderFooterView.textLabel.textColor  = [UIColor whiteColor];
        tableViewHeaderFooterView.contentView.backgroundColor = [UIColor colorWithRed:0.15 green:0.64 blue:0.08 alpha:1.0];
    }
}

// Return the cell of a Player from the game
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == SECTION_PLAYERS) {
        static NSString *CellIdentifier = @"CellPlayerList";
        ModelScorePlayer* player = [self.modelScorePlayerList objectAtIndex:indexPath.row];
        
        SBPlayersCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        // Make sure the rank is visible. Could be hidden if the cell was in edit mode and then re-use
        cell.rankLabel.alpha = 1.0;
        
        NSInteger rank = [Utilities computePlayerRank:player
                                      scorePlayerList:self.modelScorePlayerList
                                     isHigherScoreWin:[self.gameConfig.HighestScoreWin boolValue]];
        [cell initializeWith:player rank:rank];
        return cell;
    } else {
        SBActionsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CellWithActionsId" forIndexPath:indexPath];
        
        if (self.modelScorePlayerList.count > 0) {
            [cell initWithNewGameButton];
        } else {
            [cell initWithoutNewGameButton];
        }
        return cell;
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == SECTION_PLAYERS;
}

// deleteScorePlayerAndReorder
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
     if (editingStyle == UITableViewCellEditingStyleDelete) {

         [DatabaseHelper deleteScorePlayerAndReorder:self.modelScorePlayerList atRow:indexPath.row];
        
         
         NSMutableArray* cellToBeRefreshed = [[NSMutableArray alloc] init];
         for (NSUInteger i = indexPath.row; i < self.modelScorePlayerList.count; i++) {
             [cellToBeRefreshed addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }

         [self.tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
         [self.tv reloadRowsAtIndexPaths:cellToBeRefreshed withRowAnimation:UITableViewRowAnimationNone];
         
         if (self.modelScorePlayerList.count == 0) {
             NSIndexSet* indexes = [[NSIndexSet alloc] initWithIndex:1];
             [self.tv reloadSections:indexes withRowAnimation:UITableViewRowAnimationNone];
         }
     }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"OpenAddScore"]) {
        SBAddScoreToPlayerViewController *addController = (SBAddScoreToPlayerViewController*) segue.destinationViewController;
        ModelScorePlayer* getScorePlayer = [self.modelScorePlayerList objectAtIndex:[self.tv indexPathForSelectedRow].row];
        addController.scorePlayer = getScorePlayer;
    }
}

@end
