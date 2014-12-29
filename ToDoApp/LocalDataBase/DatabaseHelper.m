//
//  DatabaseHelper.m
//  TestApp
//
//  Created by Сергей on 23.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import "DatabaseHelper.h"
#import <sqlite3.h>

#define database_name @"notes"

@interface DatabaseHelper ()
{
    sqlite3* database;
}

@end

@implementation DatabaseHelper

+ (instancetype)instance
{
    static DatabaseHelper* helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DatabaseHelper alloc] init];
    });
    return helper;
}

- (id)init
{
    self = [super init];
    [self copyDatabaseIfNeed];
    [self initialize];
    return self;
}

- (NSString*)getPathToDatabase
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:database_name];
    return dataPath;
}

- (void)printDatabaseErrorMessage:(NSString*)message
{
    NSLog(@"%@. %s",message, sqlite3_errmsg(database));
}

- (void)initialize
{
    NSString* path = [self getPathToDatabase];
    int result = sqlite3_open([path UTF8String], &database);
    if(result!=SQLITE_OK)
    {
        [self printDatabaseErrorMessage:@"Can't open database"];
    }
}

- (void)copyDatabaseIfNeed
{
    NSFileManager* manager = [NSFileManager defaultManager];
    NSString* dataPath = [self getPathToDatabase];
    
    if (![manager fileExistsAtPath:dataPath])
    {
        NSError* error;
        NSString* bundlePath = [[NSBundle mainBundle] pathForResource:database_name ofType:nil];
        BOOL result = [manager copyItemAtPath:bundlePath toPath:dataPath error:&error];
        if(!result)
        {
            NSLog(@"Can't copy database. %@",error);
        }
    }
}

- (NSArray*)getNodesForGroup:(NSInteger)group
{
    NSMutableArray* notes = [NSMutableArray array];
    sqlite3_stmt* stmt;
    int result = sqlite3_prepare(database, "SELECT * FROM NOTES WHERE id_group = ?", -1, &stmt, nil);
    if(result != SQLITE_OK)
    {
        [self printDatabaseErrorMessage:@"Can't prepeare stmt."];
    }else
    {
        sqlite3_bind_int(stmt, 1, group);
        
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            NoteObject *note = [NoteObject new];
            NSInteger noteID = sqlite3_column_int(stmt, 0);
            note.noteID = noteID;
            note.groupID = group;
            char *c = (char*)sqlite3_column_text(stmt, 2);
            if(c!=nil)
            {
                note.text = [NSString stringWithUTF8String:c];
            }
            BOOL isComplete = sqlite3_column_int(stmt, 3);
            note.isComplated = isComplete;
            //get the date of item
            char *cdate = (char*)sqlite3_column_text(stmt, 4);
            if(cdate!=nil)
            {
                note.date = [NSString stringWithUTF8String:cdate];
            }

            [notes addObject:note];
        }
    }
    sqlite3_finalize(stmt);
    return [NSArray arrayWithArray:notes];
}

- (NSInteger)getNewIDForTabelName:(NSString*)tabelName
{
    int maxID = -1;
    sqlite3_stmt* stmt;
    NSString* query = [NSString stringWithFormat:@"SELECT MAX(id) FROM %@",tabelName];
    int result = sqlite3_prepare(database, [query UTF8String], -1, &stmt, nil);
    if(result != SQLITE_OK)
    {
        [self printDatabaseErrorMessage:@"Can't prepeare stmt."];
    }else
    {
        if(sqlite3_step(stmt)==SQLITE_ROW)
        {
            maxID = sqlite3_column_int(stmt, 0);
        }else
        {
            [self printDatabaseErrorMessage:@"Can't get max id for notes"];
        }
    }
    return maxID+1;
}

- (void)updateNote:(NoteObject*)objext
{
    sqlite3_stmt* stmt;
    if(objext.noteID==0)
    {
        objext.noteID = [self getNewIDForTabelName:@"NOTES"];
        if(objext.noteID == 0)
            return;
    }
    
    int result = sqlite3_prepare(database, "insert or replace into NOTES (id, id_group, note_text, iscomplate, cdate) values (?,?,?,?,?)", -1, &stmt, nil);
    if(result != SQLITE_OK)
    {
        [self printDatabaseErrorMessage:@"Can't prepeare stmt."];
    }else
    {
        sqlite3_bind_int(stmt, 1, objext.noteID);
        sqlite3_bind_int(stmt, 2, objext.groupID);
        sqlite3_bind_text(stmt, 3, [objext.text UTF8String], -1, nil);
        sqlite3_bind_int(stmt, 4, objext.isComplated);
        sqlite3_bind_text(stmt, 5, [objext.date UTF8String], -1, nil);
        
        result = sqlite3_step(stmt);
        if(result!=SQLITE_DONE)
        {
            [self printDatabaseErrorMessage:@"Can't update row"];
        }
    }
    
    sqlite3_finalize(stmt);
}

- (NSArray*)getNodeGropus
{
    NSMutableArray* notes = [NSMutableArray array];
    sqlite3_stmt* stmt;
    int result = sqlite3_prepare(database, "SELECT NOTES_GROUP.*,COUNT(NOTES.ID)FROM NOTES_GROUP LEFT JOIN NOTES ON NOTES_GROUP.id = NOTES.id_group GROUP BY NOTES_GROUP.id", -1, &stmt, nil);
    if(result != SQLITE_OK)
    {
        [self printDatabaseErrorMessage:@"Can't prepeare stmt."];
    }else
    {
        while (sqlite3_step(stmt)==SQLITE_ROW) {
            NoteGroupObject *group = [NoteGroupObject new];
            NSInteger noteID = sqlite3_column_int(stmt, 0);
            group.groupID = noteID;
            char *c = (char*)sqlite3_column_text(stmt, 1);
            if(c!=nil)
            {
                group.name = [NSString stringWithUTF8String:c];
            }
            NSInteger count = sqlite3_column_int(stmt, 2);
            group.noteCount = count;
            
            [notes addObject:group];
        }
    }
    sqlite3_finalize(stmt);
    return [NSArray arrayWithArray:notes];
}

- (void)updateNoteGroup:(NoteGroupObject*)object
{
    sqlite3_stmt* stmt;
    if(object.groupID==0)
    {
        object.groupID = [self getNewIDForTabelName:@"NOTES_GROUP"];
        if(object.groupID == 0)
            return;
    }
    
    int result = sqlite3_prepare(database, "insert or replace into NOTES_GROUP (id, name) values (?,?)", -1, &stmt, nil);
    if(result != SQLITE_OK)
    {
        [self printDatabaseErrorMessage:@"Can't prepeare stmt."];
    }else
    {
        sqlite3_bind_int(stmt, 1, object.groupID);
        sqlite3_bind_text(stmt, 2, [object.name UTF8String], -1, nil);
        
        result = sqlite3_step(stmt);
        if(result!=SQLITE_DONE)
        {
            [self printDatabaseErrorMessage:@"Can't update row"];
        }
    }
    
    sqlite3_finalize(stmt);
}
@end
