//
//  NSManagedObject+ActiveRecord.h
//  NewWindBase
//
//  Created by Marin Usalj on 4/15/12. Mod by newwindsoft  8/9/12.
//  Copyright (c) 2012 http://mnewwindsoftrr.com. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSArray+Accessors.h"

@interface NSManagedObjectContext (OActiveRecord)

@end

@interface NSManagedObject (OActiveRecord)

#pragma mark - Default Context

//- (BOOL)save;
- (void)delete;
+ (void)deleteAll;

+ (id)create;
+ (id)create:(NSDictionary *)attributes;

+ (NSArray *)all;
+ (NSArray *)where:(id)condition;
+ (NSArray *)whereFormat:(NSString *)format, ...;



#pragma mark - Custom Context

+ (id)createInContext:(NSManagedObjectContext *)context;
+ (id)create:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context;

+ (void)deleteAllInContext:(NSManagedObjectContext *)context;

+ (NSArray *)allInContext:(NSManagedObjectContext *)context;
+ (NSArray *)where:(id)condition inContext:(NSManagedObjectContext *)context;    

@end