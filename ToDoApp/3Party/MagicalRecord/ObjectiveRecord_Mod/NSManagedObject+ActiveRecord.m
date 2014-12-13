//
//  NSManagedObject+ActiveRecord.m
//  NewWindBase
//
//  Created by Marin Usalj on 4/15/12. Mod by newwindsoft  8/9/12.
//  Copyright (c) 2012 http://mnewwindsoftrr.com. All rights reserved.
//

#import "NSManagedObject+ActiveRecord.h"

@implementation NSManagedObjectContext (OActiveRecord)

@end

@implementation NSManagedObject (OActiveRecord)

#pragma mark - Finders

+ (NSArray *)all {
    return [self allInContext:[NSManagedObjectContext defaultContext]];
}

+ (NSArray *)allInContext:(NSManagedObjectContext *)context {
    
    return [self fetchWithPredicate:nil inContext:context];
}

+ (NSArray *)whereFormat:(NSString *)format, ... {
    va_list va_arguments;
    va_start(va_arguments, format);
    NSString *condition = [[NSString alloc] initWithFormat:format arguments:va_arguments];
    va_end(va_arguments);
	
    return [self where:condition];
}

+ (NSArray *)where:(id)condition {
    
    return [self where:condition
             inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSArray *)where:(id)condition inContext:(NSManagedObjectContext *)context {
    
    NSPredicate *predicate = ([condition isKindOfClass:[NSPredicate class]]) ? condition :
	[self predicateFromStringOrDict:condition];
    
    return [self fetchWithPredicate:predicate
                          inContext:context];
}


#pragma mark - Creation / Deletion

+ (id)create {
    return [self createInContext:[NSManagedObjectContext defaultContext]];
}

+ (id)create:(NSDictionary *)attributes {
    return [self create:attributes
              inContext:[NSManagedObjectContext defaultContext]];
}

+ (id)create:(NSDictionary *)attributes inContext:(NSManagedObjectContext *)context {
    NSManagedObject *newEntity = [self createInContext:context];
    
    [newEntity setValuesForKeysWithDictionary:attributes];
    return newEntity;
}

+ (id)createInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(self)
                                         inManagedObjectContext:context];
}

- (BOOL)save {
    return [self saveTheContext];
}

- (void)delete {
    NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
    [localContext deleteObject:self];
	[localContext saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
		if (error) {
			NSLog(@"Unresolved error in saving entity: %@!\n Error:%@", self, error);
		} else {
			NSLog(@"Save an object of %@ completed.", [self class]);
		}
	}];
}

+ (void)deleteAll {
    
    [self deleteAllInContext:[NSManagedObjectContext defaultContext]];
}

+ (void)deleteAllInContext:(NSManagedObjectContext *)context {
    
    [[self allInContext:context] each:^(NSManagedObject *object) {
        [object delete];
    }];
}

#pragma mark - Private

+ (NSString *)queryStringFromDictionary:(NSDictionary *)conditions {
    NSMutableString *queryString = [NSMutableString new];
    
    [conditions.allKeys each:^(id attribute) {
        [queryString appendFormat:@"%@ == '%@'", attribute, [conditions valueForKey:attribute]];
		
        if (attribute == conditions.allKeys.last) return;
        [queryString appendString:@" AND "];
    }];
    
    return queryString;
}

+ (NSPredicate *)predicateFromStringOrDict:(id)condition {
    
    if ([condition isKindOfClass:[NSString class]])
        return [NSPredicate predicateWithFormat:condition];
    
    else if ([condition isKindOfClass:[NSDictionary class]])
        return [NSPredicate predicateWithFormat:[self queryStringFromDictionary:condition]];
    
    return nil;
}

+ (NSFetchRequest *)createFetchRequestInContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [NSFetchRequest new];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self)
                                              inManagedObjectContext:context];
    [request setEntity:entity];
    return request;
}

+ (NSArray *)fetchWithPredicate:(NSPredicate *)predicate
                      inContext:(NSManagedObjectContext *)context {
    
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:predicate];
    
    NSArray *fetchedObjects = [context executeFetchRequest:request error:nil];
    if (fetchedObjects.count > 0) return fetchedObjects;
    return nil;
}

- (BOOL)saveTheContext {
    
    NSDictionary *allAttributes = [[self entity] attributesByName];
    NSAttributeDescription *oneAttribute;
    
    for (NSString *oneAttributeKey in allAttributes) {
        oneAttribute = [allAttributes objectForKey:oneAttributeKey];
        if ([oneAttribute attributeType] == NSStringAttributeType) {
            if (![self valueForKey:[oneAttribute name]]) {
                [self setValue:@"" forKey:[oneAttribute name]];
            }
        }
    }
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext defaultContext];
    NSLog(@"Start save context for %@", [self class]);
	
    if (localContext == nil) return YES;
    if (![localContext hasChanges])return YES;
    
    __block BOOL ret = YES;
	
    [localContext saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
		NSLog(@"Unresolved error in saving entity: %@!\n Error:%@", self, error);
        ret = NO;
	}];
	
    if (ret)
        NSLog(@"Save an object of '%@' done.",[self class]);
    
    return ret;
}

@end