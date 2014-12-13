//
//  UIImageView+Ext.h
//  SwiftArchitecture
//
//  Created by Tan Le on 7/12/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RamCacheImage : NSObject
{
    
}
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic, strong) NSString *imageURLString;

@end

@interface UIImageView (Ext)
{
    
}
@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) UIActivityIndicatorView *loading;
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload:(NSString *)imageURLString;
- (void)cancelDownload;

@end
