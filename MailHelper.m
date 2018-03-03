//
//  MailHelper.m
//  ScoreLog
//
//  Created by sébastien brugalières on 25/01/2014.
//
//

#import "MailHelper.h"
#import "ModelScorePlayer.h"
#import "ModelPlayer.h"
#import "ModelScoreList.h"
#import "Utilities.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ModelScoreBoard.h"
#import "ModelGameConfig.h"

@implementation MailHelper



+ (MFMailComposeViewController*) prepareContactEmail:(id<MFMailComposeViewControllerDelegate>) delegate {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];

    picker.mailComposeDelegate = delegate;

    [picker setSubject:@"ScoreLog"];

    // Set up the recipients.
    NSArray<NSString*>* emails = @[@"sebastienothers@gmail.com"];
    [picker setToRecipients:emails];

    return picker;
}


+ (MFMailComposeViewController*) prepareEmail:(id<MFMailComposeViewControllerDelegate>) delegate
                                   scoreBoard:(ModelScoreBoard*) scoreBoardModel
                                   playerList:(NSArray*) modelScorePlayerList {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = delegate;
    
    NSString* HTMLfixedTitle = NSLocalizedString(@"Game result for", "(PlayersTableViewContoller) HTML fixed part of the title email");
    NSString* mailTitle = [NSString stringWithFormat:@"%@: %@", HTMLfixedTitle,[scoreBoardModel GameName]];
    [picker setSubject:mailTitle];
    
    // Set up the recipients.
    NSArray* emailList = [MailHelper getRecipients:modelScorePlayerList];
    [picker setToRecipients:emailList];
    
    // Fill out the email body text.
    NSString *emailBody = [MailHelper convertResultToHTML:modelScorePlayerList
                                         isHigherScoreWin:[scoreBoardModel.GameConfig.HighestScoreWin boolValue]];
    [picker setMessageBody:emailBody isHTML:YES];
    
    return picker;
    
}

+(NSArray*) getRecipients:(NSArray*) modelScorePlayerList {
    NSMutableArray* emailList = [NSMutableArray arrayWithCapacity:modelScorePlayerList.count];
    for (ModelScorePlayer* scorePlayer in modelScorePlayerList) {
        if (scorePlayer.Player.email != Nil) {
            [emailList addObject:scorePlayer.Player.email];
        }
    }

    return emailList;
}


+ (NSString*) convertResultToHTML:(NSArray*) modelScorePlayerList isHigherScoreWin:(Boolean) highestScoreWin {
    
    // build the first row with the name of each player
    NSUInteger maxRoundNumber = 0;
    NSMutableString* HTMLheader = [[NSMutableString alloc] init];
    NSMutableString* HTMLTotalScore = [[NSMutableString alloc] init];
    NSMutableString* HTMLRank = [[NSMutableString alloc] init];
    NSMutableString* HTMLRound = [[NSMutableString alloc] init];
    
    NSString* HTMLtitleName = NSLocalizedString(@"Name", "(PlayersTableViewContoller) HTML title for the Name of player in the HTML Table");
    [HTMLheader appendFormat:@"<tr><th>%@</th>", HTMLtitleName];
    
    
    NSString* HTMLtitleTotalScore = NSLocalizedString(@"Total Score", "(PlayersTableViewContoller) HTML title for the Total Score in the HTML Table");
    [HTMLTotalScore appendFormat:@"<tr><th>%@</th>", HTMLtitleTotalScore];
    
    NSString* HTMLtitleRank = NSLocalizedString(@"Rank", "(PlayersTableViewContoller) HTML title for the Rank in the HTML Table");
    [HTMLRank appendFormat:@"<tr><th>%@</th>", HTMLtitleRank];
    
    NSString* HTMLtitleRound = NSLocalizedString(@"Round", "(PlayersTableViewContoller) HTML title for the Round in the HTML Table");
    [HTMLRound appendFormat:@"<tr><th>%@</th>", HTMLtitleRound];
    
    for (ModelScorePlayer* scorePlayer in modelScorePlayerList) {
        [HTMLheader appendFormat:@"<th>%@</th>", scorePlayer.Player.lastName];
        
        [HTMLTotalScore appendFormat:@"<td>%ld</td>", (long)scorePlayer.totalScore];
        
        if (scorePlayer.ScoreList.count > maxRoundNumber) {
            maxRoundNumber = scorePlayer.ScoreList.count;
        }
        [HTMLRank appendFormat:@"<td>%ld</td>",
         (long)[Utilities computePlayerRank:scorePlayer
                            scorePlayerList:modelScorePlayerList
                           isHigherScoreWin:highestScoreWin]];
        
        [HTMLRound appendFormat:@"<td>%lu</td>", (unsigned long)scorePlayer.ScoreList.count];
    }
    [HTMLheader appendString:@"</tr>"];
    [HTMLTotalScore appendString:@"</tr>"];
    
    NSString* scores = [MailHelper addScoresForAllPlayers:modelScorePlayerList maxRound:maxRoundNumber];
    
    NSMutableString* HTMLfullResult = [[NSMutableString alloc] init];
    [HTMLfullResult appendString:@"<table border=\"1\">"];
    [HTMLfullResult appendString:HTMLheader];
    [HTMLfullResult appendString:HTMLRank];
    [HTMLfullResult appendString:HTMLRound];
    [HTMLfullResult appendString:HTMLTotalScore];
    [HTMLfullResult appendString:scores];
    [HTMLfullResult appendString:@"</table>"];
    
    NSString* HTMLEndString = NSLocalizedString(@"Generated by Score Log (available on the AppStore!).", "(PlayersTableViewContoller) HTML end string"); //
    
    NSString* HTMLDownloadString = NSLocalizedString(@"Download Score log", "Download Score log");
    
    [HTMLfullResult appendFormat:@"<br>%@<br><a href=\"https://itunes.apple.com/fr/app/score-log/id478676721?mt=8\">%@</a>", HTMLEndString, HTMLDownloadString];
    
    
    return HTMLfullResult;
}

+(NSString*) addScoresForAllPlayers:(NSArray*) modelScorePlayerList maxRound:(NSUInteger) maxRoundNumber {
    // To be completed, the score should be re-order to follow the creation
    NSString* HTMLtitleScore = NSLocalizedString(@"Score", "(PlayersTableViewContoller) HTML title for the  Score in the HTML Table");
    NSMutableString* HTMLScoreList = [[NSMutableString alloc] init];
    for (int i = 0 ; i < maxRoundNumber; i++) {
        [HTMLScoreList appendString:@"<tr>"];
        if (i == 0) {
            [HTMLScoreList appendFormat:@"<th rowspan=\"%lu\">%@</th>", (unsigned long)maxRoundNumber, HTMLtitleScore];
        }
        
        NSString* rowScore = [MailHelper addRowScoreForPlayers:modelScorePlayerList row:i];
        [HTMLScoreList appendString:rowScore];
        [HTMLScoreList appendString:@"</tr>"];
    }
  
    return HTMLScoreList;
}


+(NSString*) addRowScoreForPlayers:(NSArray*) modelScorePlayerList row:(NSUInteger) index {

    NSMutableString *rowForScore = [[NSMutableString alloc] init];
    
    for (ModelScorePlayer* scorePlayer in modelScorePlayerList) {
        if (scorePlayer.ScoreList.count > index) {
            NSEnumerator* listOfScore = [scorePlayer.ScoreList objectEnumerator];
            ModelScoreList* scoreList = Nil;
            for (int k = 0; k <= index; k++) {
                scoreList = (ModelScoreList*) [listOfScore nextObject];
            }
            [rowForScore appendFormat:@"<td>%ld</td>", (long)[scoreList.Score integerValue]];
        } else {
            [rowForScore appendString:@"<td></td>"];
        }
    }
    return rowForScore;
}


@end
