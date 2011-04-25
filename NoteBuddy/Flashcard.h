//
//  Flashcard.h
//  NoteBuddy
//
//  Copyright (c) 2011 Neil Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Flashcard : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * Question;
@property (nonatomic, retain) NSString * Answer;
@property (nonatomic, retain) NSManagedObject * Course;

@end
