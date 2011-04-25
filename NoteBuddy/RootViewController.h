//
//  RootViewController.h
//  NoteBuddy
//
//  Copyright 2011 Neil Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {

}
@property (nonatomic, assign) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)insertNewObject:(id)sender;

@end
