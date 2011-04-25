//
//  OCPromptView.h
//  NoteBuddy
//
//  Copyright 2011 Neil Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCPromptView : UIAlertView {
    UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;

- (id)initWithPrompt:(NSString *)prompt delegate:(id)delegate cancelButtonTitle:(NSString *)cancelTitle acceptButtonTitle:(NSString *)acceptTitle;
- (NSString *)enteredText;

@end