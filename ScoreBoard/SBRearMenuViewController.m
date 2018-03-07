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

static const NSUInteger SECTION_GAME = 0;
static const NSUInteger SECTION_GAME_ROW_NEW_GAME = 0;
static const NSUInteger SECTION_GAME_ROW_DUPLICATE_GAME = 1;
static const NSUInteger SECTION_GAME_ROW_EDIT_HISTORICAL = 2;
static const NSUInteger SECTION_HISTORICAL = 1;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    self.theTableView.rowHeight = UITableViewAutomaticDimension;
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
    return 2;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
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



- (void) gameRowSelected:(NSUInteger) theRow {
    switch (theRow) {
        case SECTION_GAME_ROW_NEW_GAME: {
            SBPlayersViewContoller* controller = [SBGameManager sharedInstance].playerController;
            [controller startNewGame];
            self.tabBarController.selectedIndex = 0;

            //TODO: SEB
//            [self.revealViewController pushFrontViewController:self.gameNavigationController animated:TRUE];
            break;
            
        }
        case SECTION_GAME_ROW_DUPLICATE_GAME: {
            SBPlayersViewContoller* controller = [SBGameManager sharedInstance].playerController;
            [controller startNewGameWithSamePlayer];
            //TODO: SEB
//            [self.revealViewController pushFrontViewController:self.gameNavigationController animated:TRUE];
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


    self.tabBarController.selectedIndex = 0;
}



@end
