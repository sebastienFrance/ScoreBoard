//
//  HistoryTableViewController.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 18/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "ModelPlayer.h"
#import "DatabaseAccess.h"
#import "ModelScoreBoard.h"
#import "ModelGameConfig.h"
#import "ScoreBoardAppDelegate.h"
#import "HistoryGameCellCustom.h"
#import "PlayersTableViewContoller.h"

#import "ScoreLogViewController.h"
#import "DatabaseHelper.h"

@interface HistoryTableViewController()

@property (nonatomic) NSArray* scorePlayerList;

@end

@implementation HistoryTableViewController



// To be completed
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
   // self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.title = NSLocalizedString(@"Continue a game", @"(HistoryTableViewController) Title for view Continue a game");

    self.scorePlayerList = [DatabaseHelper loadHistory];
    
   [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Update the history if we are coming back from a game
    if (self.isMovingToParentViewController == NO) {
        self.scorePlayerList = [DatabaseHelper loadHistory];
        [self .tableView reloadData];
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)editButtonPushed:(UIBarButtonItem *)sender {
    if (self.editing == FALSE) {
        [self setEditing:TRUE animated:TRUE];
    } else {
        [self setEditing:FALSE animated:TRUE];
    }
}


#pragma mark - Table view data source


// There's only one section that contains all existing games
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// The Number of rows is the number of Games in the history
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.scorePlayerList count];
}

// Return a cell from the history Game
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellHistory";
    
    ModelScoreBoard* getScorePlayer = (ModelScoreBoard*) [self.scorePlayerList objectAtIndex:indexPath.row];
    
    HistoryGameCellCustom *cell = (HistoryGameCellCustom*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HistoryGameCellCustom alloc] init];
    }
    
    [cell initCellWithPlayer:getScorePlayer];
    return cell;
}



//// Method called when the "Edit" button is pressed to delete or move a row from the table
//
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


// To be analysed!!!!
- (void)setEditing:(BOOL)editing animated:(BOOL)animated { 
    [super setEditing:editing animated:animated]; 
    
    
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



//
#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"openExistingGame"]) {
        
        PlayersTableViewContoller* controller = segue.destinationViewController;
        controller.scoreBoard = self.scoreBoard;
        
        ModelScoreBoard* getScorePlayer = [self.scorePlayerList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        controller.scoreBoardModel = getScorePlayer;
        controller.gameConfig  = getScorePlayer.GameConfig;
    }
}




@end
