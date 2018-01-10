//
//  HistoryTableViewController.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 18/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SBHistoryViewController.h"
#import "ModelPlayer.h"
#import "DatabaseAccess.h"
#import "ModelScoreBoard.h"
#import "ModelGameConfig.h"
#import "ScoreBoardAppDelegate.h"
#import "SBHistoryCell.h"
#import "SBPlayersViewContoller.h"

#import "DatabaseHelper.h"

@interface SBHistoryViewController()

@property (nonatomic) NSArray* scorePlayerList;
@property (weak, nonatomic) IBOutlet UITableView *theTableView;

@end

@implementation SBHistoryViewController


#pragma mark - View lifecycle

- (void)viewDidLoad
{
   // self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.title = NSLocalizedString(@"Continue a game", @"(HistoryTableViewController) Title for view Continue a game");

    self.scorePlayerList = [DatabaseHelper loadHistory];
    
    self.theTableView.dataSource = self;
    self.theTableView.delegate = self;
    
   [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Update the history if we are coming back from a game
    if (self.isMovingToParentViewController == NO) {
        self.scorePlayerList = [DatabaseHelper loadHistory];
        [self.theTableView reloadData];
    }
}

- (IBAction)editButtonPushed:(UIBarButtonItem *)sender {
    if (self.theTableView.editing == FALSE) {
        [self.theTableView setEditing:TRUE animated:TRUE];
    } else {
        [self.theTableView setEditing:FALSE animated:TRUE];
    }
}

- (IBAction)doneButtonPushed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:TRUE completion:Nil];
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
    
    SBHistoryCell *cell = (SBHistoryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SBHistoryCell alloc] init];
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
