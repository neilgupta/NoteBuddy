//
//  FlashcardEditor.m
//  NoteBuddy
//
//  Copyright 2011 Neil Gupta. All rights reserved.
//

#import "FlashcardEditor.h"
#import "FlashcardListView.h"

@implementation FlashcardEditor

@synthesize question;
@synthesize answer;

FlashcardListView *listview;

- (id)initWithListView:(FlashcardListView *)view {
    self = [super init];
    listview = view;
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [question becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight)
        return YES;
    else
        return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ((textView == question && [textView.text isEqualToString:@"Enter question here..."]) ||
        (textView == answer && [textView.text isEqualToString:@"Enter answer here..."]))
        [textView setText:@""];        
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        if (textView == question) {
            [textView setText:@"Enter question here..."];
        } else if (textView == answer)
            [textView setText:@"Enter answer here..."];
    }    
}

// Save button was pressed
- (IBAction)UIButton:(id)sender {
    // Do not allow blank questions
    if ([question.text isEqualToString:@""] || [question.text isEqualToString:@"Enter question here..."]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Save Flashcard" message:@"You must enter a question." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    // Do not allow blank answers either
    else if ([answer.text isEqualToString:@""] || [answer.text isEqualToString:@"Enter answer here..."]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Save Flashcard" message:@"You must enter an answer." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    // create card and dismiss view
    else {
        [listview createFlashcardWithQuestion:question.text withAnswer:answer.text];
        [self dismissModalViewControllerAnimated:YES];
    }
}

// Cancel button was pressed
- (IBAction)UIButtonCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
