//
//  ModelPlayer.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 25/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ModelPlayer.h"
#import "ModelScorePlayer.h"


@implementation ModelPlayer
@dynamic email;
@dynamic firstName;
@dynamic lastName;
@dynamic picture;
@dynamic ScorePlayer;

@end
@implementation ImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}


- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
    return uiImage;
}
@end