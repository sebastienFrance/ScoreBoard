//
//  DatabaseHelper.m
//  ScoreLog
//
//  Created by sébastien brugalières on 24/01/2014.
//
//

#import "DatabaseHelper.h"
#import "DatabaseAccess.h"
#import "ModelScoreBoard.h"
#import "ModelPlayer.h"
#import "ModelGameConfig.h"
#import "ModelScorePlayer.h"
#import "ModelScoreList.h"

@implementation DatabaseHelper

// Fetch all Games stored in the Core Data
// They are sorted by Date
+ (NSArray*) loadHistory {
    // Fetch all ModelScoreBoard from CoreData and order the result by Date
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ModelScoreBoard" inManagedObjectContext:[[DatabaseAccess sharedManager] managedObjectContext]];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"GameDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray* scorePlayerList = [[[[DatabaseAccess sharedManager] managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    if (scorePlayerList == nil) {
        // Handle the error.
    }
    
    return scorePlayerList;
}

+ (ModelPlayer*) addPlayer:(NSString*) lastName picture:(UIImage*) thePicture email:(NSString*) theEmail  {
    ModelPlayer *player = (ModelPlayer *)[NSEntityDescription insertNewObjectForEntityForName:@"ModelPlayer" inManagedObjectContext:[[DatabaseAccess sharedManager] managedObjectContext]];
    [player setLastName:lastName];
    [player setPicture:thePicture];
    [player setEmail:theEmail];
    
    NSError *error = nil;
    if (![[[DatabaseAccess sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"AddPlayerController::save -> Error Save!");
        // Handle the error.
    }
    return player;
}
+ (ModelScoreBoard*) addModelScoreBoard {
    ModelScoreBoard* scoreBoardModel = (ModelScoreBoard *)[NSEntityDescription insertNewObjectForEntityForName:@"ModelScoreBoard" inManagedObjectContext:[[DatabaseAccess sharedManager] managedObjectContext]];
    
    ModelGameConfig* gameConfig = (ModelGameConfig *) [NSEntityDescription insertNewObjectForEntityForName:@"ModelGameConfig" inManagedObjectContext:[[DatabaseAccess sharedManager] managedObjectContext]];
    [scoreBoardModel setGameConfig:gameConfig];
    [gameConfig setScoreBoard:scoreBoardModel];
    
    NSDate* currentDate = [NSDate date];
    
    NSString* gameName = NSLocalizedString(@"Game", @"(PlayersTableViewContoller) Default game name");
    
    [scoreBoardModel setGameDate:currentDate];
    [scoreBoardModel setGameName:gameName];
    
    
    NSError *error = nil;
    if (![[[DatabaseAccess sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"PlayerTableViewController::addPlayer -> Error Save!");
        // Handle the error.
    }
    
    return scoreBoardModel;
}


+ (ModelScorePlayer*) addModelScorePlayer:(ModelPlayer *) newPlayer scoreBoardModel:(ModelScoreBoard*) theScoreBoardModel {
    ModelScorePlayer* newScorePlayer = (ModelScorePlayer *)[NSEntityDescription insertNewObjectForEntityForName:@"ModelScorePlayer" inManagedObjectContext:[[DatabaseAccess sharedManager] managedObjectContext]];
    
    // initialize the bi-directional relationship
    [newScorePlayer setPlayer:newPlayer];
    [newPlayer addScorePlayerObject:newScorePlayer];
    
    [theScoreBoardModel addScoreListObject:newScorePlayer];
    [newScorePlayer setScoreBoard:theScoreBoardModel];
    [newScorePlayer setDisplayOrder:[NSNumber numberWithInteger:[theScoreBoardModel.ScoreList count]]];
    
    NSError *error = nil;
    if (![[[DatabaseAccess sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"PlayerTableViewController::showPlayer::save -> Error Save!");
        // Handle the error.
    }

    return newScorePlayer;
}

+(NSMutableArray*) getSortedScoreList:(ModelScorePlayer*) scorePlayer {
    // Fetch data from the CoreData and store it in a table. Result is ordered by parameter OrderOfDisplay
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DisplayOrder" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
	
	NSMutableArray *sortedModelScoreList = [[NSMutableArray alloc] initWithArray:[scorePlayer.ScoreList allObjects]];
	[sortedModelScoreList sortUsingDescriptors:sortDescriptors];
    return sortedModelScoreList;
}

+(void) addScoreTo:(ModelScorePlayer*) player score:(NSUInteger) NewScore {
    // Record the new score in the CoreData
    NSManagedObjectContext* managedContext= [[DatabaseAccess sharedManager] managedObjectContext];
    ModelScoreList *scoreList = (ModelScoreList *)[NSEntityDescription insertNewObjectForEntityForName:@"ModelScoreList" inManagedObjectContext:managedContext];
    [scoreList setScore:[NSNumber numberWithInteger:NewScore]];
    [scoreList setScorePlayer:player];
    [player addScoreListObject:scoreList];
    [scoreList setDisplayOrder:[NSNumber numberWithUnsignedInteger:[player.ScoreList count]]];
    
    NSError *error = nil;
    if (![managedContext save:&error]) {
        NSLog(@"AddScoreToPlayerController::save -> Error Save!");
        // Handle the error.
    }

}

+(void) deleteScoreFrom:(NSMutableArray*) modelScoreList index:(NSUInteger) row {
    ModelScoreList* scoreList = (ModelScoreList*) [modelScoreList objectAtIndex:row];
    [modelScoreList removeObjectAtIndex:row];
    
     NSManagedObjectContext* context = [[DatabaseAccess sharedManager] managedObjectContext];
    [context deleteObject:scoreList];
    
    // Re-compute the DisplayOrder after the row has been removed.
    for (NSInteger i = row; i < [modelScoreList count]; i++) {
        scoreList = (ModelScoreList *) [modelScoreList objectAtIndex:i];
        scoreList.DisplayOrder = [NSNumber numberWithInteger:i];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        // Handle the error.
        NSLog(@"AddScoreToPlayerController::commitEditingStyle -> Error Save!");
    }
}

+(void) deleteScoreBoard:(ModelScoreBoard*) scoreBoardModel {
    NSManagedObjectContext* context = [[DatabaseAccess sharedManager] managedObjectContext];
    [context deleteObject:scoreBoardModel];
    
    
    NSError *error = nil;
    if (![context save:&error]) {
        // Handle the error.
    }

}

+(NSMutableArray*) reorderPlayer:(NSMutableArray*) modelScorePlayerList highestScoreWin:(Boolean) isHighestScoreWin {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"totalScore" ascending:!isHighestScoreWin];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    
    NSMutableArray *sortedModelScorePlayer = [[NSMutableArray alloc] initWithArray:modelScorePlayerList];
    [sortedModelScorePlayer sortUsingDescriptors:sortDescriptors];
    
    
    ModelScorePlayer* currPlayer = Nil;
    for (NSUInteger i = 0; i < sortedModelScorePlayer.count; i++) {
        currPlayer = (ModelScorePlayer*) [sortedModelScorePlayer objectAtIndex:i];
        currPlayer.DisplayOrder = [NSNumber numberWithInteger:i];
    }
    
    NSError *error = nil;
    if (![[[DatabaseAccess sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"PlayerTableViewController::showPlayer::save -> Error Save!");
        // Handle the error.
    }

    return sortedModelScorePlayer;
}

+(ModelScoreBoard *) duplicateGame:(ModelScoreBoard*) modelGame {
    ModelScoreBoard* scoreBoardModel = (ModelScoreBoard *)[NSEntityDescription insertNewObjectForEntityForName:@"ModelScoreBoard"
                                                                                        inManagedObjectContext:[[DatabaseAccess sharedManager]
                                                                                                        managedObjectContext]];
    
    ModelGameConfig* gameConfig = (ModelGameConfig *) [NSEntityDescription insertNewObjectForEntityForName:@"ModelGameConfig"
                                                                                    inManagedObjectContext:[[DatabaseAccess sharedManager] managedObjectContext]];
    
    // initialize the ScoreBoardModel
    NSString* gameName = NSLocalizedString(@"Game copy", @"(PlayersTableViewContoller) Default game name copy");
    NSDate* currentDate = [NSDate date];
    [scoreBoardModel setGameDate:currentDate];
    
    [scoreBoardModel setGameName:gameName];
    [scoreBoardModel setGameConfig:gameConfig];
    
    // initialize the GameConfig as it was in previous game
    [gameConfig setScoreBoard:scoreBoardModel];
    [gameConfig setOrderBy:modelGame.GameConfig.OrderBy];
    [gameConfig setNegativeScore:modelGame.GameConfig.NegativeScore];
    [gameConfig setHighestScoreWin:modelGame.GameConfig.HighestScoreWin];
    
    // copy the ModelScoreBoard and ModelPlayer
    NSSet* modelScoreBoardList = modelGame.ScoreList;
    NSEnumerator* enumModelScorePlayer = [modelScoreBoardList objectEnumerator];
    
    ModelScorePlayer* currentScorePlayer = Nil;
    ModelScorePlayer* newScorePlayer = Nil;
    ModelPlayer* currentPlayer = Nil;
    
    while ((currentScorePlayer = (ModelScorePlayer*) enumModelScorePlayer.nextObject) != Nil) {
        currentPlayer = currentScorePlayer.Player;
        
        // Create the new ModelScorePlayer
        newScorePlayer = (ModelScorePlayer *)[NSEntityDescription insertNewObjectForEntityForName:@"ModelScorePlayer" inManagedObjectContext:[[DatabaseAccess sharedManager] managedObjectContext]];
        
        // init ModelScorePlayer object
        newScorePlayer.DisplayOrder = currentScorePlayer.DisplayOrder;
        newScorePlayer.ScoreBoard = scoreBoardModel;
        
        newScorePlayer.Player = currentPlayer;
        [currentPlayer addScorePlayerObject:newScorePlayer];
    }
    
    // Record all in CoreData
    NSError *error = nil;
    if (![[[DatabaseAccess sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"PlayerTableViewController::addPlayer -> Error Save!");
        
        // Handle the error.
    }

    return scoreBoardModel;
}

+(void) deleteScorePlayerAndReorder:(NSMutableArray*) modelScorePlayerList atRow:(NSUInteger) row  {
    // Delete the row from the data source and release memory
    ModelScorePlayer* scorePlayer = [modelScorePlayerList objectAtIndex:row];
    [modelScorePlayerList removeObjectAtIndex:row];
    
    NSManagedObjectContext* context = [[DatabaseAccess sharedManager] managedObjectContext];
    [context deleteObject:scorePlayer];
    
    // Re-compute the DisplayOrder after the row that has been removed.
    for (NSInteger i = row; i < [modelScorePlayerList count]; i++) {
        ModelScorePlayer* currentPlayer = (ModelScorePlayer *) [modelScorePlayerList objectAtIndex:i];
        currentPlayer.DisplayOrder = [NSNumber numberWithInteger:i];
    }
    
    
    NSError *error = nil;
    if (![context save:&error]) {
        // Handle the error.
        NSLog(@"PlayerTableViewController::commitEditingStyle -> Save error");
    }

}

+(NSMutableArray*) loadScorePlayerList:(ModelScoreBoard*) scoreBoardModel {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"DisplayOrder" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    
    NSMutableArray *sortedModelScorePlayer = [[NSMutableArray alloc] initWithArray:[scoreBoardModel.ScoreList allObjects]];
    [sortedModelScorePlayer sortUsingDescriptors:sortDescriptors];
    return sortedModelScorePlayer;

}


@end
