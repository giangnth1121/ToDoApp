//
//  SWVerticalLabel.h
//  SRPLS
//
//  Created by Tan Le on 7/20/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData+MagicalRecord.h"

@interface DataManager : NSObject
{

}
+ (DataManager*)sharedInstance;
+ (BOOL)saveAllChanges;
+ (void)revertLocalChanges;
@end
