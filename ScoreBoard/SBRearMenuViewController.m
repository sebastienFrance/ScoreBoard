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
#import "DatabaseAccess.h"
#import "SBHistoryCell.h"

#import "ModelPlayer.h"
#import "ModelScoreBoard.h"
#import "ModelGameConfig.h"
#import "ScoreBoardAppDelegate.h"
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

static NSUInteger const SECTION_START_NEW_GAME = 0;
static NSUInteger const SECTION_HISTORY = 1;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    self.theTableView.rowHeight = UITableViewAutomaticDimension;
    self.theTableView.tableFooterView = [[UIView alloc] initWithFrame: CGRectZero];
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // when the view is re-displayed (when the user has selected the tab)
    // we need to reload the content of the table and to refresh it (because it may have changed)
    self.scorePlayerList = [DatabaseHelper loadHistory];
    [self.theTableView reloadData];
    
    if (!self.splitViewController.isCollapsed) {
        [self performSegueWithIdentifier:@"ShowStartGameDetails" sender:Nil];
    }
}


- (IBAction)startNewGame:(UIButton *)sender {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self performSegueWithIdentifier:@"showGame" sender:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == SECTION_HISTORY) {
        return self.scorePlayerList.count;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == SECTION_HISTORY) {
     return NSLocalizedString(@"Historical Game", @"(RearMenu) Title Historical section");
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SECTION_HISTORY) {
        return [self cellForHistorical:tableView row:indexPath.row];
    } else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"StartNewGameCellId" forIndexPath:indexPath];
        return cell;
    }
}

-(UITableViewCell*) cellForHistorical:(UITableView *)tableView row:(NSUInteger) theRow {
    static NSString *CellIdentifier = @"CellHistory";
    
    ModelScoreBoard* getScorePlayer = (ModelScoreBoard*) [self.scorePlayerList objectAtIndex:theRow];
    
    SBHistoryCell *cell = (SBHistoryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SBHistoryCell alloc] init];
    }
    
    ModelScoreBoard* currentGame = [SBGameManager sharedInstance].playerController.scoreBoardModel;
    BOOL isOngoingGame = currentGame!= Nil && currentGame.objectID == getScorePlayer.objectID;
    
    [cell initCellWithPlayer:getScorePlayer isOngoingGame:isOngoingGame];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showGame" sender:indexPath];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGame"]) {
        SBPlayersViewContoller* playerController = (SBPlayersViewContoller*) segue.destinationViewController;
        NSIndexPath* index = (NSIndexPath*) sender;
        if (index.section == SECTION_HISTORY) {
            ModelScoreBoard* getScorePlayer = [self.scorePlayerList objectAtIndex:index.row];
            playerController.scoreBoardModel = getScorePlayer;
            playerController.gameConfig = getScorePlayer.GameConfig;
        }
    }
}

//***************

//// Method called when the "Edit" button is pressed to delete or move a row from the table
//
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == SECTION_HISTORY;
}


// To be analysed!!!!
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    //[super setEditing:editing animated:animated];


    if (!editing) {
        NSManagedObjectContext* context = [[DatabaseAccess sharedManager] managedObjectContext];

        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"PlayerTableViewController::setEditing -> Error Save!");
            // Handle the error.
        }
    }
}

//
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        // Delete the row from the data source
        ModelScoreBoard* scoreBoardModel = (ModelScoreBoard*) [self.scorePlayerList objectAtIndex:indexPath.row];

        [DatabaseHelper deleteScoreBoard:scoreBoardModel];
        self.scorePlayerList = [DatabaseHelper loadHistory];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


@end
