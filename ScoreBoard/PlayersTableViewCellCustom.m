//
//  PlayersTableViewCellCustom.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayersTableViewCellCustom.h"

@implementation PlayersTableViewCellCustom

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
