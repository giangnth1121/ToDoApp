//
//  SWVerticalLabel.h
//  SRPLS
//
//  Created by Tan Le on 7/20/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import "Datamanager.h"

@implementation DataManager

+ (DataManager*)sharedInstance {
    
    static DataManager *dataManager;
    @synchronized(self){
        if (dataManager == nil) {
            dataManager = [[self alloc] init];
        }
        return dataManager;
    }
}

+ (BOOL)saveAllChanges
{
    __block BOOL isSaved = YES;
    
    if ([NSManagedObjectContext defaultContext].hasChanges) {
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            isSaved = success;
            [[NSNotificationCenter defaultCenter] postNotificationName:dataHasChanged object:nil];
            if (success) {
                NSLog(@"DataManager:saveAllChanges: DONE - %i, %i", isSaved, success);
            }
            else
            {
                NSLog(@"DataManager:saveAllChanges: ERROR %@", error.localizedDescription);
            }
        }];
    }
    else
    {
        NSLog(@"DataManager:saveAllChanges: hasChanges=NO --> nothing saved");
    }
    
    return isSaved;
}

+ (void)clearAllUnSavedEntities:(NSManagedObject *)entities, ...
{
    va_list args;
    va_start(args, entities);
    for (NSManagedObject *arg = entities; arg != nil; arg = va_arg(args, NSManagedObject*))
    {
        [arg deleteEntity];
        [DataManager saveAllChanges];
    }
    va_end(args);
}

+ (void)revertLocalChanges
{
    if ([NSManagedObjectContext defaultContext].undoManager.canUndo) {
        [[NSManagedObjectContext defaultContext].undoManager endUndoGrouping];
        [[NSManagedObjectContext defaultContext].undoManager undo];
    }
}
@end
