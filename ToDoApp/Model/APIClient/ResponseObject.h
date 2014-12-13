//
//  ResponseObject.h
//  NewWindBase
//
//  Created by newwindsoft  on 8/6/13.
//  Copyright (c) 2013 newwindsoft . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseObject : NSObject
{

}
@property (nonatomic, strong) id data;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDictionary *info;
@end
