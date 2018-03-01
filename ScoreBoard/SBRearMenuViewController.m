//
//  ScoreBoardRearMenuTableViewController.m
//  ScoreLog
//
//  Created by sébastien brugalières on 28/09/2014.
//
//

#import "SBRearMenuViewController.h"
#import "SBRearMenuCell.h"
#import "DatabaseHelper.h"
#import "SBHistoryCell.h"
#import "DatabaseAccess.h"


#import "ModelPlayer.h"
#import "ModelScoreBoard.h"
#import "ModelGameConfig.h"
#import "ScoreBoardAppDelegate.h"
#import "SBHistoryCell.h"
#import "SBPlayersViewContoller.h"
#import "SWRevealViewController.h"
#import "SBGameManager.h"
#import "SBPlayersViewContoller.h"
#import "SBGameTypeViewController.h"

@interface SBRearMenuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *theTableView;
@property (nonatomic) NSArray* scorePlayerList;


// Warning : the NavigationController must never be deallocated else we cannot return to the Game view!!!
@property(nonatomic, strong) UINavigationController* gameNavigationController;

@end

@implementation SBRearMenuViewController

static const NSUInteger SECTION_CURRENT_GAME = 0;
static const NSUInteger SECTION_CURRENT_GAME_DISPLAY_IT = 0;
static const NSUInteger SECTION_CURRENT_GAME_OPTIONS = 1;
static const NSUInteger SECTION_GAME = 1;
static const NSUInteger SECTION_GAME_ROW_NEW_GAME = 0;
static const NSUInteger SECTION_GAME_ROW_DUPLICATE_GAME = 1;
static const NSUInteger SECTION_GAME_ROW_EDIT_HISTORICAL = 2;
static const NSUInteger SECTION_HISTORICAL = 2;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    
    self.gameNavigationController = (UINavigationController *)self.revealViewController.frontViewController;
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
    self.scorePlayerList = [DatabaseHelper loadHistory];
    [self.theTableView reloadData];
    [self.theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:FALSE];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SECTION_HISTORICAL) {
        return 62.0;
    } else {
        return 38.0;
    }
  
}


// The number of rows is the number of players in the game
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_CURRENT_GAME:
            return 2;
        case SECTION_GAME:
            return 3;
        case SECTION_HISTORICAL:
            return [self.scorePlayerList count];
        default: {
            NSLog(@"%s : unknown section",__PRETTY_FUNCTION__);
            return 0;
        }
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SECTION_CURRENT_GAME:
            return  NSLocalizedString(@"Current Game", @"(RearMenu) Title Current Game section");
        case SECTION_GAME:
            return  NSLocalizedString(@"Game", @"(RearMenu) Title Game section");
        case SECTION_HISTORICAL:
            return NSLocalizedString(@"Historical Game", @"(RearMenu) Title Historical section");
        default: {
            NSLog(@"%s : unknown section",__PRETTY_FUNCTION__);
            return @"";
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SECTION_CURRENT_GAME: {
            return [self cellForCurrentGame:tableView row:indexPath.row];
        }
        case SECTION_GAME: {
            return [self cellForGame:tableView row:indexPath.row];
        }
        case SECTION_HISTORICAL: {
            return [self cellForHistorical:tableView row:indexPath.row];
        }
        default: {
            NSLog(@"%s : unknown section",__PRETTY_FUNCTION__);
            return Nil;
        }
    }
    
}

-(UITableViewCell*) cellForCurrentGame:(UITableView *)tableView row:(NSUInteger) theRow {
    static NSString* currentGameId = @"StartNewGameCellId";
    SBRearMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:currentGameId];
    if (cell == nil) {
        cell = [[SBRearMenuCell alloc] init];
    }
    
    switch (theRow) {
        case SECTION_CURRENT_GAME_DISPLAY_IT: {
            cell.label.text = NSLocalizedString(@"Display current game", @"(RearMenu) Title Display current game row");
            break;
        }
        case SECTION_CURRENT_GAME_OPTIONS: {
            cell.label.text = NSLocalizedString(@"Options", @"(RearMenu) Title Options current game row");
            break;
        }
        default: {
            NSLog(@"%s unknown case", __PRETTY_FUNCTION__);
        }
    }
    
    return cell;
}

- (UITableViewCell*) cellForGame:(UITableView *)tableView row:(NSUInteger) theRow {
    static NSString* newGameId = @"StartNewGameCellId";
    SBRearMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:newGameId];
    if (cell == nil) {
        cell = [[SBRearMenuCell alloc] init];
    }

    switch (theRow) {
        case SECTION_GAME_ROW_NEW_GAME: {
            cell.label.text = NSLocalizedString(@"Start a new game", @"(RearMenu) Title new empty Game row");
            break;
        }
        case SECTION_GAME_ROW_DUPLICATE_GAME: {
            cell.label.text = NSLocalizedString(@"Duplicate game", @"(RearMenu) Title Duplicate Game row");
            break;
        }
        case SECTION_GAME_ROW_EDIT_HISTORICAL: {
            cell.label.text = NSLocalizedString(@"Edit historical games", @"(RearMenu) Title Edit Historical Game row");
            break;
        }
        default: {
            NSLog(@"%s unknown rows", __PRETTY_FUNCTION__);
            return Nil;
        }
    }
    return cell;
}

-(UITableViewCell*) cellForHistorical:(UITableView *)tableView row:(NSUInteger) theRow {
    static NSString *CellIdentifier = @"CellHistory";
    
    ModelScoreBoard* getScorePlayer = (ModelScoreBoard*) [self.scorePlayerList objectAtIndex:theRow];
    
    SBHistoryCell *cell = (SBHistoryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SBHistoryCell alloc] init];
    }
    
    [cell initCellWithPlayer:getScorePlayer];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SECTION_CURRENT_GAME: {
            [self currentGameRowSelected:indexPath.row];
            break;
        }
        case SECTION_GAME: {
            [self gameRowSelected:indexPath.row];
            break;
        }
        case SECTION_HISTORICAL: {
            [self historicalRowSelected:indexPath.row];
            break;
        }
    }
}

-(void) currentGameRowSelected:(NSUInteger) theRow {
    
    switch (theRow) {
        case SECTION_CURRENT_GAME_DISPLAY_IT: {
            [self.revealViewController pushFrontViewController:self.gameNavigationController animated:TRUE];
            break;
        }
        case SECTION_CURRENT_GAME_OPTIONS: {
            if ([SBGameManager sharedInstance].playerController.isGameStarted) {
                [self performSegueWithIdentifier:@"showOptions" sender:Nil];
            } else {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Error", Nil)
                                                                               message:NSLocalizedString(@"Options cannot be configured while a game is not started.", Nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            break;
        }
        default: {
            NSLog(@"%s unknown case", __PRETTY_FUNCTION__);
        }
    }
}


- (void) gameRowSelected:(NSUInteger) theRow {
    switch (theRow) {
        case SECTION_GAME_ROW_NEW_GAME: {
            SBPlayersViewContoller* controller = [SBGameManager sharedInstance].playerController;
            [controller startNewGame];
            [self.revealViewController pushFrontViewController:self.gameNavigationController animated:TRUE];
            break;
            
        }
        case SECTION_GAME_ROW_DUPLICATE_GAME: {
            SBPlayersViewContoller* controller = [SBGameManager sharedInstance].playerController;
            [controller startNewGameWithSamePlayer];
            [self.revealViewController pushFrontViewController:self.gameNavigationController animated:TRUE];
            break;
            
        }
        case SECTION_GAME_ROW_EDIT_HISTORICAL: {
            [self performSegueWithIdentifier:@"presentHistoricalEditor" sender:Nil];
            break;
        }
        default: {
            NSLog(@"%s unknown rows", __PRETTY_FUNCTION__);
        }
    }
 }

-(void) historicalRowSelected:(NSUInteger) theRow {
    SBPlayersViewContoller* controller = [SBGameManager sharedInstance].playerController;
    
    ModelScoreBoard* getScorePlayer = [self.scorePlayerList objectAtIndex:[self.theTableView indexPathForSelectedRow].row];
    
    [controller updateWithHistoricalGame:getScorePlayer config:getScorePlayer.GameConfig];
    
    [self.revealViewController pushFrontViewController:self.gameNavigationController animated:TRUE];
}



@end
