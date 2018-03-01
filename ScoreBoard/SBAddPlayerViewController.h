//
//  AddPlayerController.h
//  ScoreBoard
//
//  Created by sébastien brugalières on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPlayersViewContoller.h"
#import <CoreData/CoreData.h>
#import <ContactsUI/ContactsUI.h>



@interface SBAddPlayerViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, CNContactPickerDelegate>

@end
