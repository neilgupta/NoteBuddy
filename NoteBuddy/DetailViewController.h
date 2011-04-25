//
//  DetailViewController.h
//  NoteBuddy
//
//  Copyright 2011 Neil Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <GameKit/GameKit.h>

@class RootViewController;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, GKSessionDelegate, GKPeerPickerControllerDelegate> {

    // Session Object
    GKSession *studySession;
    // PeerPicker Object
    GKPeerPickerController *peerPicker;
    // Array of peers connected
    NSMutableArray *peers;
}

@property (retain) GKSession *studySession;

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) NSManagedObject *detailItem;

@property (nonatomic, retain) IBOutlet UITextView *questionView;

@property (nonatomic, retain) IBOutlet UIImageView *bg;

@property (nonatomic, retain) IBOutlet UILabel *label;

@property (nonatomic, assign) IBOutlet RootViewController *rootViewController;

- (IBAction)insertNewObject:(id)sender;
- (IBAction)UIButton:(id)sender;
- (IBAction)ConnectButton:(id)sender;
- (IBAction)ShareButton:(id)sender;

@end
