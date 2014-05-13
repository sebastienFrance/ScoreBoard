//
//  ScoreLogViewController.m
//  ScoreLog
//
//  Created by sébastien brugalières on 23/01/2014.
//
//

#import "ScoreLogViewController.h"
#import "HistoryTableViewController.h"
#import "DatabaseHelper.h"
#import "PlayersTableViewContoller.h"

@interface ScoreLogViewController ()


@end

@implementation ScoreLogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = TRUE;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isMovingToParentViewController == NO) {
        self.navigationController.navigationBarHidden = TRUE;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL) prefersStatusBarHidden {
    return TRUE;
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.navigationController.navigationBarHidden = FALSE;
    if ([segue.identifier isEqualToString:@"openGameHistory"]) {
         HistoryTableViewController* controller = segue.destinationViewController;
        controller.scoreBoard = self;
    } else if ([segue.identifier isEqualToString:@"StartNewGame"]) {
        PlayersTableViewContoller* controller = segue.destinationViewController;
        controller.scoreBoard = self;
    }
}



@end
