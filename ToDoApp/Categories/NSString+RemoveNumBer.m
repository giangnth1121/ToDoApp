//
//  NSString+RemoveNumBer.m
//  SRPLS
//
//  Created by Nguyen Ha Giang on 7/31/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import "NSString+RemoveNumBer.h"

@implementation NSString (RemoveNumBer)

- (NSString *)removeNumbersFromString:(NSString *)string
{
    NSString *trimmedString = nil;
    NSCharacterSet *numbersSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    trimmedString = [string stringByTrimmingCharactersInSet:numbersSet];
    return trimmedString;
}

@end
