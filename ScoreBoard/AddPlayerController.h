//
//  AddPlayerController.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayersTableViewContoller.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreData/CoreData.h>



@interface AddPlayerController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate> 

@property(nonatomic, retain) PlayersTableViewContoller *delegate;

@end
