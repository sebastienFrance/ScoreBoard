//
//  AddPlayerController.m
//  ScoreBoard
//
//  Created by sébastien brugalières on 18/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SBAddPlayerViewController.h"
#import "SBPlayersViewContoller.h"
#import "ModelPlayer.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "DatabaseAccess.h"
#import "ModelScoreBoard.h"
#import "UIImage+Resize.h"
#import "DatabaseHelper.h"
#import "SBGameManager.h"
#import <ContactsUI/ContactsUI.h>

@interface SBAddPlayerViewController()

@property(nonatomic, retain) NSString *email;

@property (nonatomic, retain) IBOutlet UIImageView *playerPicture;
@property (nonatomic, retain) IBOutlet UITextField *playerName;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;

@end

@implementation SBAddPlayerViewController



#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // Configure the navigation bar
   // self.navigationItem.title = NSLocalizedString(@"Add Player", "(AddPlayerController) View title for Add a new player");
    
    [self setDefaultPlayerName];
    // Open the keyboard directly on the Player Name
     [self.playerName becomeFirstResponder];
    self.playerName.delegate = self;
}

// Display the photo when the view is refreshed
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void) setDefaultPlayerName {
    // Create the default player Name
    
    ModelScoreBoard* model = [[SBGameManager sharedInstance].playerController scoreBoardModel];
    NSSet* playerList = [model ScoreList];
    NSInteger playerNumber = 0;
    if (playerList != Nil) {
        playerNumber = [playerList count];
    }
    self.playerName.text = [NSString stringWithFormat:@"%@ %ld", NSLocalizedString(@"Player", @"(AddPlayerController) String used to build default player name"), (long)playerNumber];
    self.playerName.placeholder = NSLocalizedString(@"Player Name", @"(AddPlayerController) Place holder string for text file when creating a new player");
}

// To be analyzed !!!
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.playerName) {
        [self.playerName resignFirstResponder];
    }
    return YES;
}


#pragma mark - Buttons callback
- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:Nil];
}

- (IBAction)addButtonPressed:(UIBarButtonItem *)sender {
    ModelPlayer* player = [DatabaseHelper addPlayer:self.playerName.text picture:self.playerPicture.image email:self.email];
    [[SBGameManager sharedInstance].playerController addPlayer:player];
    
    [self dismissViewControllerAnimated:TRUE completion:Nil];

}


- (IBAction)contactButtonPressed:(UIButton *)sender {
    CNContactPickerViewController *picker = [[CNContactPickerViewController alloc] init];
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:Nil];
}

- (IBAction)cameraButtonPressed:(UIBarButtonItem *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];

    imagePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == TRUE) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
            //imagePicker.modalInPopover = TRUE;
            imagePicker.modalPresentationStyle = UIModalPresentationPopover;
            if (imagePicker.popoverPresentationController != Nil) {
                imagePicker.popoverPresentationController.barButtonItem = self.cameraButton;
                imagePicker.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            }
        }
    }
    
    [self presentViewController:imagePicker animated:YES completion:Nil];
}


+ (UIImage*) resizeImage:(UIImage*) theImage {
    return [theImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                          bounds:CGSizeMake(250, 250)
                            interpolationQuality:kCGInterpolationDefault];
}


#pragma mark - UIImagePickerControllerDelegate

// Extract the original image from the ImagePicker and store it.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage* image = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];

    
    self.playerPicture.image = [SBAddPlayerViewController resizeImage:image];
    
    [self  dismissViewControllerAnimated:YES completion:Nil];
}


// Close the ImagePicker and release it
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self  dismissViewControllerAnimated:YES completion:Nil];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSRange textFieldRange = NSMakeRange(0, [textField.text length]);
    if (NSEqualRanges(range, textFieldRange) && [string length] == 0) {
        
        // Disable the Save button because the player name is empty
        self.addButton.enabled = FALSE;
        self.email = nil;
    } else {
        // Text field is not empty so we have the button to clear the text field and the Save button is enabled
        self.addButton.enabled = TRUE;
    }
    
    return YES;
}

// User has pressed the clear button from the text field. The clear button is replaced by the button to select a player
// from the address book.
- (BOOL)textFieldShouldClear:(UITextField *)textField {

    self.addButton.enabled = FALSE;
    
    self.email = Nil;
    return TRUE;    
}

#pragma mark - CNContactPickerDelegate

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
    NSString *firstName = contact.givenName;
    NSString *lastName = contact.familyName;
    
    NSString *email = Nil;
    if (contact.emailAddresses.count > 0) {
        email = contact.emailAddresses[0].value;
    }
    
    if (contact.imageDataAvailable) {
        self.playerPicture.image =  [[UIImage alloc] initWithData:contact.imageData];
    }
    
    // build the player name and close the Address Book picker
    self.playerName.text = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    [self  dismissViewControllerAnimated:YES completion:Nil];
    
    // enable the save button because the Player Name is not empty
    self.addButton.enabled = TRUE;

}



@end
