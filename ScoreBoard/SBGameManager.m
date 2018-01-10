//
//  GameManager.m
//  ScoreLog
//
//  Created by sébastien brugalières on 30/09/2014.
//
//

#import "SBGameManager.h"

@implementation SBGameManager


+(SBGameManager*)sharedInstance
{
    static dispatch_once_t pred;
    static SBGameManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[SBGameManager alloc] init];
    });
    return sharedInstance;
}


@end
