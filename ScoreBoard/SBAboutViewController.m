//
//  GameTypeScoreBoardAbout.m
//  ScoreBoard
//
//  Created by Sebastien Brugalieres on 27/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SBAboutViewController.h"

@interface SBAboutViewController()

@property (nonatomic) NSString *htmlString;
@property (nonatomic) NSURL *baseURL;

@property(nonatomic, retain) IBOutlet UIWebView* webView;
@end

@implementation SBAboutViewController


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    NSString *localizedAboutHTML = NSLocalizedString(@"About", @"(ScoreBoardAboutController) Filename of the HTML page to be displayed depending on the language");
    NSString *path = [[NSBundle mainBundle] pathForResource:localizedAboutHTML ofType:@"html"];
    self.baseURL = [NSURL fileURLWithPath:path];
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    self.htmlString = [[NSString alloc] initWithData:
                       [readHandle readDataToEndOfFile] encoding:NSUTF8StringEncoding];

    
    self.webView.delegate = self;
    self.webView.hidden = TRUE;
    [self.webView loadHTMLString:self.htmlString baseURL:self.baseURL];
    [super viewWillAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)webViewDidFinishLoad:(UIWebView *)argWebView {
    argWebView.hidden = FALSE; 
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Error: %@", [error localizedDescription]);
}

@end
