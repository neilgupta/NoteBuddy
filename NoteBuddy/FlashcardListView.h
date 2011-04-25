//
//  FlashcardListView.h
//  NoteBuddy
//
//  Copyright 2011 Neil Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface FlashcardListView : UITableViewController <NSFetchedResultsControllerDelegate> {
    
}
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSManagedObject *course;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)insertNewObject:(id)sender;
- (id)initWithStyle:(UITableViewStyle)style withCourse:(NSManagedObject *)object;
- (void)createFlashcardWithQuestion:(NSString *)question withAnswer:(NSString *)answer;

@end
