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


+ (MFMailComposeViewController*) prepareEmail:(id<MFMailComposeViewControllerDelegate>) delegate
                                   scoreBoard:(ModelScoreBoard*) scoreBoardModel
                                   playerList:(NSArray*) modelScorePlayerList {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate = delegate;
    
    NSString* HTMLfixedTitle = NSLocalizedString(@"Game result for", "(PlayersTableViewContoller) HTML fixed part of the title email");
    NSString* mailTitle = [NSString stringWithFormat:@"%@: %@", HTMLfixedTitle,[scoreBoardModel GameName]];
    [picker setSubject:mailTitle];
    
    // Set up the recipients.
    NSMutableArray* emailList = [NSMutableArray arrayWithCapacity:modelScorePlayerList.count];
    for (int i = 0; i < modelScorePlayerList.count; i++) {
        ModelScorePlayer* scorePlayer = (ModelScorePlayer*) [modelScorePlayerList objectAtIndex:i];
        if (scorePlayer.Player.email != Nil) {
            [emailList addObject:scorePlayer.Player.email];
        }
    }
    [picker setToRecipients:emailList];
    
    
    // Fill out the email body text.
    NSString *emailBody = [MailHelper convertResultToHTML:modelScorePlayerList isHigherScoreWin:[scoreBoardModel.GameConfig.HighestScoreWin boolValue]];
    [picker setMessageBody:emailBody isHTML:YES];
    
    return picker;
    
}


+ (NSString*) convertResultToHTML:(NSArray*) modelScorePlayerList isHigherScoreWin:(Boolean) highestScoreWin {
    
    // build the first row with the name of each player
    int maxRoundNumber = 0;
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
    
    for (int i = 0; i < modelScorePlayerList.count; i++) {
        ModelScorePlayer* scorePlayer = (ModelScorePlayer*) [modelScorePlayerList objectAtIndex:i];
        [HTMLheader appendFormat:@"<th>%@</th>", scorePlayer.Player.lastName];
        
        [HTMLTotalScore appendFormat:@"<td>%d</td>", scorePlayer.totalScore];
        
        if (scorePlayer.ScoreList.count > maxRoundNumber) {
            maxRoundNumber = scorePlayer.ScoreList.count;
        }
        [HTMLRank appendFormat:@"<td>%d</td>",
         [Utilities computePlayerRank:scorePlayer scorePlayerList:modelScorePlayerList isHigherScoreWin:highestScoreWin]];
        [HTMLRound appendFormat:@"<td>%d</td>", scorePlayer.ScoreList.count];
    }
    [HTMLheader appendString:@"</tr>"];
    [HTMLTotalScore appendString:@"</tr>"];
    
    // To be completed, the score should be re-order to follow the creation
    NSString* HTMLtitleScore = NSLocalizedString(@"Score", "(PlayersTableViewContoller) HTML title for the  Score in the HTML Table");
    NSMutableString* HTMLScoreList = [[NSMutableString alloc] init];
    for (int i = 0 ; i < maxRoundNumber; i++) {
        [HTMLScoreList appendString:@"<tr>"];
        if (i == 0) {
            [HTMLScoreList appendFormat:@"<th rowspan=\"%d\">%@</th>", maxRoundNumber, HTMLtitleScore];
        }
        for (int j = 0; j < modelScorePlayerList.count; j++) {
            ModelScorePlayer* scorePlayer = (ModelScorePlayer*) [modelScorePlayerList objectAtIndex:j];
            if (scorePlayer.ScoreList.count > i) {
                NSEnumerator* listOfScore = [scorePlayer.ScoreList objectEnumerator];
                ModelScoreList* scoreList = Nil;
                for (int k = 0; k <= i; k++) {
                    scoreList = (ModelScoreList*) [listOfScore nextObject];
                }
                [HTMLScoreList appendFormat:@"<td>%d</td>", [scoreList.Score integerValue]];
            } else {
                [HTMLScoreList appendString:@"<td></td>"];
                
            }
        }
        [HTMLScoreList appendString:@"</tr>"];
    }
    
    NSMutableString* HTMLfullResult = [[NSMutableString alloc] init];
    [HTMLfullResult appendString:@"<table border=\"1\">"];
    [HTMLfullResult appendString:HTMLheader];
    [HTMLfullResult appendString:HTMLRank];
    [HTMLfullResult appendString:HTMLRound];
    [HTMLfullResult appendString:HTMLTotalScore];
    [HTMLfullResult appendString:HTMLScoreList];
    [HTMLfullResult appendString:@"</table>"];
    
    NSString* HTMLEndString = NSLocalizedString(@"Generated by Score Log (available on the AppStore!).", "(PlayersTableViewContoller) HTML end string"); //
    
    NSString* HTMLDownloadString = NSLocalizedString(@"Download Score log", "Download Score log");
    
    [HTMLfullResult appendFormat:@"<br>%@<br><a href=\"https://itunes.apple.com/fr/app/score-log/id478676721?mt=8\">%@</a>", HTMLEndString, HTMLDownloadString];
    
    
    return HTMLfullResult;
}



@end
