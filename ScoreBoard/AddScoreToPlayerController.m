//
//  AddScoreToPlayer.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 23/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AddScoreToPlayerController.h"
#import "ModelPlayer.h"
#import "ModelScorePlayer.h"
#import "ModelScoreList.h"
#import "DatabaseAccess.h"
#import "ModelGameConfig.h"
#import "DatabaseHelper.h"

@interface AddScoreToPlayerController()

@property (nonatomic) NSInteger lowestScore;
@property (nonatomic) NSInteger highestScore;


@property(nonatomic, retain) IBOutlet UITextField *scoreToAdd;
@property(nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic, retain) IBOutlet UIImageView *photoOfPlayer;
@property(nonatomic, retain) IBOutlet UITableView * tableViewScoreHistory;

@end

@implementation AddScoreToPlayerController


// Constructor, nothing special
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// To be completed
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // Configure the navigation bar
     self.navigationItem.title = [[self.scorePlayer Player] lastName];

	
    // set the image of the player
    self.photoOfPlayer.image = [[self.scorePlayer Player] picture];
 
    // Configure the table height for the score history
    self.tableViewScoreHistory.rowHeight = 37.0;
    self.tableViewScoreHistory.delegate = self;
    self.tableViewScoreHistory.dataSource = self;
    
    self.modelScoreList = [DatabaseHelper getSortedScoreList:self.scorePlayer];

    // compute the lowest and highest score of the player
    [self initializeHighestAndLowestScore];

    self.scoreToAdd.placeholder = NSLocalizedString(@"Score", @"(AddScoreToPlayerController) score placeholder for AddScore view");
    
    // Display the +/- sign only if we can have negative score in the game.
    self.segmentedControl.hidden = ![self.gameConfig.NegativeScore boolValue];
    
    [self.scoreToAdd becomeFirstResponder];
    
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tgr.delegate = self;
    [self.tableViewScoreHistory addGestureRecognizer:tgr];

    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableViewScoreHistory setEditing:FALSE];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    [self.scoreToAdd resignFirstResponder];
    return TRUE;
}

- (void)viewTapped:(UITapGestureRecognizer *)tgr {
 }


-(void) initializeHighestAndLowestScore {
    if ([self.modelScoreList count] > 0) {
        self.lowestScore = self.highestScore = [[[self.modelScoreList objectAtIndex:0] Score] integerValue];
    }
    
    int i = 1;
    while (i < [self.modelScoreList count]) {
        NSInteger currScore = [[[self.modelScoreList objectAtIndex:i] Score]integerValue];
        if (currScore > self.highestScore) {
            self.highestScore = currScore;
        }
        if (currScore < self.lowestScore) {
            self.lowestScore = currScore;
        }
        i++;
    }

}

#pragma mark - Buttons callback

- (IBAction)addScoreButtonPushed:(UIBarButtonItem *)sender {
    [self save];
    self.scoreToAdd.text = @"";
    self.modelScoreList = [DatabaseHelper getSortedScoreList:self.scorePlayer];
    [self initializeHighestAndLowestScore];
    [self.tableViewScoreHistory reloadData];
    [self.scoreToAdd resignFirstResponder];
}

// Called when the "Add" button has been pressed. Extract the score and the sign.
// The new score is converted to an integer and then added to the Player
- (void)save {
    
    if ([self.scoreToAdd.text length] > 0) {
        NSInteger score = [self.scoreToAdd.text integerValue];
        if ((self.gameConfig.NegativeScore) && (self.segmentedControl.selectedSegmentIndex == 1)) {
            score = score * -1;
        }
        
        [DatabaseHelper addScoreTo:self.scorePlayer score:score];
        
        
        // Refresh the score of the player and close the modal view
        [self.scorePlayer refreshScore];
        [self.delegate updateScoreToPlayer];
    } else {
        [self.delegate cancelUpdateScoreToPlayer];
    }
}


#pragma mark - UITableViewDataSource protocol
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// There's one row per score in the CoreData
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.modelScoreList count];
}

// Method called when the table view is displayed. 
// A new UITableViewCell is created if no row was already existing for this position
// else it re-use the existing UITableViewCell and we just need to update its content
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ScoreHistory";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    } 
    
    [self initCellWithScoreHistory:cell scoreIndexPath:indexPath];
    return cell;
}

// Initialize the row with the score
- (void) initCellWithScoreHistory:(UITableViewCell*) cell scoreIndexPath:(NSIndexPath *)indexPath {

    ModelScoreList* scoreList = (ModelScoreList*) [self.modelScoreList objectAtIndex:indexPath.row];
    NSInteger score = [scoreList.Score integerValue];
    
    UILabel* textLabel = cell.textLabel;
    textLabel.text = [NSString stringWithFormat:@"%d -> %d",[indexPath indexAtPosition:1] +1,score]; 

    if (self.lowestScore == score) {
       textLabel.textColor = [UIColor redColor]; 
    } else {
        if (self.highestScore == score) {
            textLabel.textColor = [UIColor greenColor]; 
        } else {
           textLabel.textColor = [UIColor blackColor];            
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - UITableViewDelegate protocol
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Method called when the "Edit" button is pressed to delete or move a row from the table
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Delete the row from the data source and release memory
        
        [DatabaseHelper deleteScoreFrom:self.modelScoreList index:indexPath.row];
        
        // Refresh the score of the player
        [self.scorePlayer refreshScore];
        [self.delegate updateScoreToPlayer];
        
        // Remove smoothly the table from the view
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Method called to re-arrange the table view (a row is moved)
// We cannot move a row in this table
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

//A row cannot be moved in this table
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FALSE;
}


#pragma mark - UITextFieldDelegate protocol

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSRange textFieldRange = NSMakeRange(0, [textField.text length]);

    // if the Score is empty the Save button is disabled else it's enabled
    if (NSEqualRanges(range, textFieldRange) && [string length] == 0) {
        self.navigationItem.rightBarButtonItem.enabled = false; 
    } else {
        textField.clearButtonMode = UITextFieldViewModeAlways;
        self.navigationItem.rightBarButtonItem.enabled = true; 
    }
    return YES;
}

// The Score is empty and so the Save button is disabled
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem.enabled = false;    
    textField.rightViewMode=UITextFieldViewModeAlways;
    return TRUE;    
}

@end
