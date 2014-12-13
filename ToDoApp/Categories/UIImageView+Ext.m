//
//  UIImageView+Ext.m
//  SwiftArchitecture
//
//  Created by Tan Le on 7/12/14.
//  Copyright (c) 2014 Tan Le. All rights reserved.
//

#import "UIImageView+Ext.h"

@implementation RamCacheImage

@end

@implementation UIImageView (Ext)
@dynamic imageURLString;
@dynamic loading;
@dynamic imageConnection;
@dynamic activeDownload;
@dynamic completionHandler;

- (void)startDownload:(NSString *)imageURLString {
    
    self.imageURLString = imageURLString;
    //If on flag |caching| will be check if this.RamCachingImage ready for exist then load image from RAM ortherwise get image from server

    [self getImageFromServer];
}

//Private method get image data from server
- (void)getImageFromServer {
    
    if (!self.loading) {
        
        self.loading = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.loading.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self.loading setHidesWhenStopped:YES];
        [self addSubview:self.loading];
    }
    
    self.activeDownload = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.imageURLString]];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.imageConnection = conn;
    [self.loading startAnimating];
}

- (void)cancelDownload {
    
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
    [self.loading stopAnimating];
    self.loading = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    [self.loading stopAnimating];
    self.loading = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    if (image.size.width != self.bounds.size.width || image.size.height != self.bounds.size.height)
	{
        CGSize itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
		UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.image = image;
    }
    
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
    
    //Stop loading
    [self.loading stopAnimating];
    self.loading = nil;
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
}
@end
