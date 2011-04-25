//
//  DetailViewController.m
//  NoteBuddy
//
//  Copyright 2011 Neil Gupta. All rights reserved.
//

#import "DetailViewController.h"

#import "RootViewController.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize toolbar=_toolbar;
@synthesize detailItem=_detailItem;
@synthesize rootViewController=_rootViewController;
@synthesize questionView=_questionView;
@synthesize popoverController=_myPopoverController;

@synthesize label;
@synthesize bg;
@synthesize studySession;

UIButton *btnFlipCard;
UIButton *btnShare;

#pragma mark - Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(NSManagedObject *)managedObject
{
	if (_detailItem != managedObject) {
		[_detailItem release];
		_detailItem = [managedObject retain];
        // Update the view.
        [self configureView];
	}
    
    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }		
}

- (void)configureView
{
    // Create "Show Answer" button
    btnFlipCard = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnFlipCard addTarget:self action:@selector(UIButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnFlipCard setTitle:@"Show Answer" forState:UIControlStateNormal];
    btnFlipCard.frame = CGRectMake(115, 445, 232, 37);
    [self.view addSubview:btnFlipCard];

    // Create "Share Flashcard" button
    btnShare = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnShare addTarget:self action:@selector(ShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [btnShare setTitle:@"Share Flashcard" forState:UIControlStateNormal];
    btnShare.frame = CGRectMake(374, 445, 232, 37);
    [self.view addSubview:btnShare];
        
    // Update background image to show notecard
    self.bg.image = [UIImage imageNamed:@"detailView.png"];

    // Load question text into textfield and set label
    self.label.text = @"Question";
    [self.questionView setText:[[self.detailItem valueForKey:@"Question"] description]];
}

// Toggles textview with question or answer
- (IBAction)UIButton:(id)sender 
{   
    UIButton *button = (UIButton*) sender;
    NSString *state = [button.currentTitle substringFromIndex:5];
    // load textView content
    [self.questionView setText:[[self.detailItem valueForKey:state] description]];
    // change button title to the original label title
    [button setTitle:[NSString stringWithFormat:@"Show %@", self.label.text] forState:UIControlStateNormal];
    // update label title to new state
    self.label.text = state;
}

// Find peers to connect to
- (IBAction)ConnectButton:(id)sender 
{   
    [peerPicker show];
}

// Encode and share currect card with peers
- (IBAction)ShareButton:(id)sender 
{   
    // Show an error if we are not connected to any peers
    if ([peers count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connected Peers" message:@"You must connect to at least one peer first. Push the Connect button." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    
    // Convert flashcard data into an array and send it using GameKit session
    NSArray *data = [[NSArray alloc] initWithObjects:[[self.detailItem valueForKey:@"Question"] description],[[self.detailItem valueForKey:@"Answer"] description], [[((NSManagedObject*)[self.detailItem valueForKey:@"Course"]) valueForKey:@"Name"] description], nil];
    [studySession sendDataToAllPeers:[NSKeyedArchiver archivedDataWithRootObject:data] withDataMode:GKSendDataReliable error:nil];
}

#pragma mark -
#pragma mark GKPeerPickerControllerDelegate

// This creates a unique Connection Type for this particular applictaion
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type{
    // Create a session with a unique session ID - displayName:nil = Takes the iPhone Name
    GKSession* session = [[GKSession alloc] initWithSessionID:@"com.metamorphium.notebuddy" displayName:nil sessionMode:GKSessionModePeer];
    return [session autorelease];
}

// Tells us that the peer was connected
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session
{
    
    // Get the session and assign it locally
    self.studySession = session;
    session.delegate = self;
    
    //No need for picker anymore
    [picker dismiss];
}

// Function to receive data when sent from peer
// basically checks to see if flashcard already exists, if so, does nothing.
// otherwise, creates flashcard, as well as course if necessary
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    //Convert received NSData to NSArray
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    // Search for this flashcard in local Core Data database to see if it already exists
    
    NSManagedObjectContext *managedObjectContext = _rootViewController.managedObjectContext;
    
    // Create fetch request for finding Flashcard.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Flashcard" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Sort by question content
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Question" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];

    // Get the flashcard that matches the attributes of the one just received by GameKit
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(Question = %@) AND (Answer = %@) AND (Course.Name = %@)", [array objectAtIndex:0], [array objectAtIndex:1], [array objectAtIndex:2]];
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];

    NSError *error;
    [aFetchedResultsController performFetch:&error];
    
    if ([[aFetchedResultsController fetchedObjects] count] == 0) {
        // this flashcard does not exist in database
        // let's see if its Course exists
        
        // Create the fetch request for finding Course.
        NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity2 = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:managedObjectContext];
        [fetchRequest2 setEntity:entity2];
                
        // Sort by course name
        NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"Name" ascending:NO];
        NSArray *sortDescriptors2 = [[NSArray alloc] initWithObjects:sortDescriptor2, nil];
        [fetchRequest2 setSortDescriptors:sortDescriptors2];

        // Get the Course that matches the received Flashcard's course name
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"Name = %@", [array objectAtIndex:2]];
        [fetchRequest2 setPredicate:predicate2];
                
        NSFetchedResultsController *aFetchedResultsController2 = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest2 managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        [fetchRequest2 release];
        [sortDescriptor2 release];
        [sortDescriptors2 release];
        
        NSError *error2;
        [aFetchedResultsController2 performFetch:&error2];
        
        NSManagedObject *course;

        if ([[aFetchedResultsController2 fetchedObjects] count] == 0) {
            // the course does not exist either, let's create it
            
            // Create a new managed Course instance with received name
            course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:managedObjectContext];            
            [course setValue:[array objectAtIndex:2] forKey:@"Name"];
            
            // Save the context.
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        } else
            // Course does exist, grab it from CoreData
            course = [[aFetchedResultsController2 fetchedObjects] objectAtIndex:0];
        
        // Now create the new flashcard and add it the course from above
        NSManagedObject *newFlashcard = [NSEntityDescription insertNewObjectForEntityForName:@"Flashcard" inManagedObjectContext:managedObjectContext];
        
        // Set attributes from received data
        [newFlashcard setValue:[array objectAtIndex:0] forKey:@"Question"];
        [newFlashcard setValue:[array objectAtIndex:1] forKey:@"Answer"];
        NSMutableSet *flashcards = [course mutableSetValueForKey:@"Flashcards"];
        [flashcards addObject:newFlashcard];
        
        // Save the context.
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark -
#pragma mark GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state{
    
    if(state == GKPeerStateConnected){
        // Add the peer to the Array
        [peers addObject:peerID];
        
        NSString *str = [NSString stringWithFormat:@"Connected with %@",[session displayNameForPeer:peerID]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected" message:str delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        // Used to acknowledge that we will be sending data
        [session setDataReceiveHandler:self withContext:nil];        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {    
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight)
        return YES;
    else
        return NO;
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc
{
    // Commented out to disable portrait support for SplitView for now
    // Reason: did not have time to design portrait UI layout
    
    /*
    // update title of button to title of top navigation controller (Courses or Questions)
    barButtonItem.title = [[_rootViewController navigationController] topViewController].title;
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
     */
    
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    peerPicker = [[GKPeerPickerController alloc] init];
    peerPicker.delegate = self;
    peerPicker.connectionTypesMask = GKPeerPickerConnectionTypeNearby;
    peers = [[NSMutableArray alloc] init];
}


- (void)viewDidUnload
{
	[super viewDidUnload];
    
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [_myPopoverController release];
    [_toolbar release];
    [_rootViewController release];
    [_detailItem release];
    [_questionView release];
    [btnFlipCard release];
    [btnShare release];
    [peers release];
    [peerPicker release];
    [super dealloc];
}

#pragma mark - Object insertion

- (IBAction)insertNewObject:(id)sender
{
    // handle Add button in RootViewController
	[self.rootViewController insertNewObject:sender];
}

@end
