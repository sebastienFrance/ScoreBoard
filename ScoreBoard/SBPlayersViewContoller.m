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

@interface SBPlayersViewContoller()

@property (nonatomic, retain) IBOutlet UITableView *tv;
@property (nonatomic, retain) IBOutlet UIView *tbView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *mailButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *reorderPlayersButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButton;

@property (retain, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottonProperties;
@property (nonatomic) NSMutableArray* modelScorePlayerList;


@end

@implementation SBPlayersViewContoller



-(Boolean) isGameStarted {
    if (self.gameConfig != Nil) {
        return TRUE;
    } else {
        return FALSE;
    }
}

#pragma mark - View lifecycle


// Fetch the content of the current game (List of Players). It's ordered with the DisplayOrder field.
- (void)viewDidLoad
{
    [SBGameManager sharedInstance].playerController = self;
    
    self.tv.dataSource = self;
    self.tv.delegate = self;
    
    [self initializeNewGame];
}


// When a modal view is closed then this method is called. Use it to re-display the ADBanner view
// but only if an Ad was previously loaded
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

// the current view will disappear because a new modal will be displayed or we quit the game
// hide the bannerview
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void) initializeScorePlayerListMember {
    if (self.scoreBoardModel != Nil) {
        // Fetch the data from the coreData and store it in a table. Result is ordered by parameter DisplayOrder
        self.modelScorePlayerList =[DatabaseHelper loadScorePlayerList:self.scoreBoardModel];
    } else {
        self.modelScorePlayerList = [[NSMutableArray alloc] init];
    }
}

- (void) startNewGame {
    [self initializeNewGame];
    [self.tv reloadData];
}


-(void) startNewGameWithSamePlayer {
    if (self.scoreBoardModel != Nil) {
        self.scoreBoardModel = [DatabaseHelper duplicateGame:self.scoreBoardModel];
        self.gameConfig = self.scoreBoardModel.GameConfig;
        
        [self initializeScorePlayerListMember];
        self.title = self.scoreBoardModel.GameName;
        
        NSIndexSet* sectionIndex = [NSIndexSet indexSetWithIndex:0];
        [self.tv reloadSections:sectionIndex withRowAnimation:UITableViewRowAnimationRight];
    }
}

-(void) initializeNewGame {
    self.title = NSLocalizedString(@"Game", @"(PlayersTableViewContoller) Default game name");
    self.modelScorePlayerList = [[NSMutableArray alloc] init];
    [self enableDisableButton];
}

- (void) updateWithHistoricalGame:(ModelScoreBoard*) scoreBoardModel config:(ModelGameConfig*) gameConfig {
    self.scoreBoardModel = scoreBoardModel;
    self.gameConfig = gameConfig;
    
    self.title = self.scoreBoardModel.GameName;
    self.modelScorePlayerList =[DatabaseHelper loadScorePlayerList:self.scoreBoardModel];
    
    [self enableDisableButton];
    
    [self.tv reloadData];
}

#pragma mark - Utilities
-(void) enableDisableButton {
    if ((self.scoreBoardModel != Nil) && (self.scoreBoardModel.ScoreList.count > 0)) {
        self.tv.hidden = FALSE;
        self.mailButton.enabled = TRUE;
        if (self.scoreBoardModel.ScoreList.count > 1) {
            self.reorderPlayersButton.enabled = TRUE;
        } else {
            self.reorderPlayersButton.enabled = FALSE;
        }
    } else {
        self.tv.hidden = true;
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
    
    NSMutableArray *sortedModelScorePlayer = [DatabaseHelper reorderPlayer:self.modelScorePlayerList
                                                           highestScoreWin:self.gameConfig.HighestScoreWin.boolValue];

    NSArray* visibleCells = [self.tv indexPathsForVisibleRows];
    NSMutableArray* cellsToBeRefreshed = [[NSMutableArray alloc] initWithCapacity:visibleCells.count];
    NSIndexPath* currIndex = Nil;
    ModelScorePlayer* currModelScorePlayer = Nil;
    ModelScorePlayer* currOrderdModelScorePlayer = Nil;
    
    for (NSUInteger i = 0; i < visibleCells.count; i++) {
        currIndex = (NSIndexPath*) [visibleCells objectAtIndex:i];
        currModelScorePlayer = (ModelScorePlayer* ) [self.modelScorePlayerList objectAtIndex:currIndex.row];
        currOrderdModelScorePlayer = (ModelScorePlayer* ) [sortedModelScorePlayer objectAtIndex:currIndex.row];
        
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
}


// Method called when the view to configure the game is closed
// Need to refresh the table view because the content can be displayed differently
- (void) endGameType {
    self.title = self.scoreBoardModel.GameName;
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

    
    NSArray *insertIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:[self.modelScorePlayerList count]-1 inSection:0],
                                 nil];

    // need to refresh also the visible screen because maybe the game already started and we need to update the rank
    // for example if highestScore win == false then the new player with score = 0 could have a better rank than others players
    
    // need to get all visible cells and compare with the new player for the score.
    // Get Score from the cell to be removed to compute the cell for which the rank must be updated
     NSInteger newPlayerDefaultScore = 0;  
    
    BOOL highestScoreWin = self.gameConfig.HighestScoreWin.boolValue;
    
    // Get the list of visible cells to build from this list the cells that must be refreshed
    NSArray* visibleCells = [self.tv indexPathsForVisibleRows];
    NSMutableArray* cellsTorefresh = [[NSMutableArray alloc] initWithCapacity:(visibleCells.count) ];
    
    for (NSUInteger i = 0 , j = 0; i < visibleCells.count; i++) {
        NSIndexPath* tempIndexPath = [visibleCells objectAtIndex:i];
        
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



#pragma mark - UITableViewDataSource protocol

// The number of rows is the number of players in the game
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self enableDisableButton];
    return self.modelScorePlayerList.count;
}

// Return the cell of a Player from the game
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellPlayerList";
    ModelScorePlayer* player = [self.modelScorePlayerList objectAtIndex:indexPath.row];
    
    SBPlayersCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SBPlayersCell alloc] init];
    } else {
        // Make sure the rank is visible. Could be hidden if the cell was in edit mode and then re-use
        cell.rankLabel.alpha = 1.0;
        cell.rankSharp.alpha = 1.0;
    }

     NSInteger rank = [Utilities computePlayerRank:player
                                   scorePlayerList:self.modelScorePlayerList
                                  isHigherScoreWin:[self.gameConfig.HighestScoreWin boolValue]];
    [cell initializeWith:player rank:rank];
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
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
         
         
     }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



#pragma mark - Segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"OpenAddScore"]) {
        UINavigationController* navController = segue.destinationViewController;
        SBAddScoreToPlayerViewController *addController = (SBAddScoreToPlayerViewController*) navController.topViewController;
        ModelScorePlayer* getScorePlayer = (ModelScorePlayer*) [self.modelScorePlayerList objectAtIndex:[self.tv indexPathForSelectedRow].row];
        addController.scorePlayer = getScorePlayer;
    }
}

@end
