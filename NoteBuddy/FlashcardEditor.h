//
//  FlashcardEditor.h
//  NoteBuddy
//
//  Copyright 2011 Neil Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlashcardListView;

@interface FlashcardEditor : UIViewController <UITextViewDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UITextView *question;
@property (nonatomic, retain) IBOutlet UITextView *answer;

- (id)initWithListView:(FlashcardListView *)view;
- (IBAction)UIButton:(id)sender;
- (IBAction)UIButtonCancel:(id)sender;
- (void)textViewDidBeginEditing:(UITextView *)textView;
- (void)textViewDidEndEditing:(UITextView *)textView;

@end
