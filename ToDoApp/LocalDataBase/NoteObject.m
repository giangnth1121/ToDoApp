//
//  NoteObject.m
//  TestApp
//
//  Created by Сергей on 23.07.14.
//  Copyright (c) 2014 Вячеслав Ковалев. All rights reserved.
//

#import "NoteObject.h"

@implementation NoteObject
-(instancetype)init
{
    self = [super init];
    self.text = @"";
    self.date = @"";
    return self;
}
@end
