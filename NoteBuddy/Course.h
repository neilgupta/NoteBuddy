//
//  Course.h
//  NoteBuddy
//
//  Copyright (c) 2011 Neil Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Flashcard;

@interface Course : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) Flashcard * Flashcards;

@end
