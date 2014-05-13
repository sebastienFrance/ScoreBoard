//
//  MailHelper.h
//  ScoreLog
//
//  Created by sébastien brugalières on 25/01/2014.
//
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@class ModelScoreBoard;

@interface MailHelper : NSObject

+ (MFMailComposeViewController*) prepareEmail:(id<MFMailComposeViewControllerDelegate>) delegate
                                   scoreBoard:(ModelScoreBoard*) scoreBoardModel
                                   playerList:(NSArray*) modelScorePlayerList;
@end
