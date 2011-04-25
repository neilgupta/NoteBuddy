//
//  OCPromptView.m
//  NoteBuddy
//
//  Copyright 2011 Neil Gupta. All rights reserved.
//

/*
 * Subview of UIAlertView to have a textField, simulates prompt from iTunes store
 * Created using tutorial from http://www.iostipsandtricks.com/using-uialertview-as-a-text-prompt/
 */

#import "OCPromptView.h"

@implementation OCPromptView

@synthesize textField;

- (id)initWithPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle {
    while ([prompt sizeWithFont:[UIFont systemFontOfSize:18.0]].width > 240.0) {
        prompt = [NSString stringWithFormat:@"%@...", [prompt substringToIndex:[prompt length] - 4]];
    }
    // add TextField to AlertView
    if ((self = [super initWithTitle:prompt message:@"\n" delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:acceptTitle, nil])) {
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 31.0)]; 
        [theTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [theTextField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [theTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [theTextField setBackgroundColor:[UIColor clearColor]];
        [theTextField setTextAlignment:UITextAlignmentCenter];
        
        [self addSubview:theTextField];
        
        self.textField = theTextField;
        [theTextField release];
    }
    return self;
}

// Display keyboard on show
- (void)show {
    [textField becomeFirstResponder];
    [super show];
}

// Return value of textfield
- (NSString *)enteredText {
    return textField.text;
}

- (void)dealloc {
    [textField release];
    [super dealloc];
}

@end