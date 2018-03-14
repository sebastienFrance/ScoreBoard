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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.scorePlayerList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
     return NSLocalizedString(@"Historical Game", @"(RearMenu) Title Historical section");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellForHistorical:tableView row:indexPath.row];
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
    [self historicalRowSelected:indexPath.row];
}

//***************

//// Method called when the "Edit" button is pressed to delete or move a row from the table
//
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // The current game cannot be deleted
    ModelScoreBoard* scoreBoardModel = (ModelScoreBoard*) [self.scorePlayerList objectAtIndex:indexPath.row];
    
    SBPlayersViewContoller* controller = [SBGameManager sharedInstance].playerController;
    ModelScoreBoard* currentScoreBoardModel = controller.scoreBoardModel;
    
    // When there's no current game or when the current game is not the current row, then the current row could be deleted
    return (currentScoreBoardModel == Nil || scoreBoardModel.objectID != currentScoreBoardModel.objectID);
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

-(void) historicalRowSelected:(NSUInteger) theRow {
    SBPlayersViewContoller* controller = [SBGameManager sharedInstance].playerController;
    
    ModelScoreBoard* getScorePlayer = [self.scorePlayerList objectAtIndex:[self.theTableView indexPathForSelectedRow].row];
    
    [controller updateWithHistoricalGame:getScorePlayer config:getScorePlayer.GameConfig];

    self.tabBarController.selectedIndex = 0;
}

@end
