//
//  RNLocalSubstitutionCache.m
//  html5
//
//  Created by 玉平 孙 on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RNLocalSubstitutionCache.h"
#include <CommonCrypto/CommonDigest.h>

@implementation RNLocalSubstitutionCache
-(id)init{
    if([super init]){
        _cachedResponses = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
    [_cachedResponses release];
}
-(NSString*)stringtoMd5:(NSString*)string{
    
    
    const char *value = [string UTF8String];
    unsigned char outputBuffer[16];
    CC_MD5(value, strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:16 * 2];
    for(NSInteger count = 0; count < 16; count++) {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return [outputString autorelease];
    
}
- (NSString *)mimeTypeForPath:(NSString *)originalPath
{
    if(originalPath){
        if([originalPath hasSuffix:@".js"]){
            return @"text/plain";	            
        }
        if([originalPath hasSuffix:@".png"]){
            return @"image/png";	
        }
        if([originalPath hasSuffix:@".html"]){
            return @"text/plain";	
        }
    }
    return  nil;
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request{
    //
	// Get the path for the request
	//
	NSString *pathString = [[request URL] absoluteString];
	
	//
	// See if we have a substitution file for this path
	//
    /*
	NSString *substitutionFileName = [_cachedResponses objectForKey:pathString];
	if (!substitutionFileName)
	{
		//
		// No substitution file, return the default cache response
		//
		return [super cachedResponseForRequest:request];
	}
    */
    //
	// If we've already created a cache entry for this path, then return it.
	//
	NSCachedURLResponse *cachedResponse = [_cachedResponses objectForKey:pathString];
	if (cachedResponse)
	{
		return cachedResponse;
	}
	
	//
	// Get the path to the substitution file
	//
    //	NSString *substitutionFilePath =
    //		[[NSBundle mainBundle]
    //			pathForResource:[substitutionFileName stringByDeletingPathExtension]
    //			ofType:[substitutionFileName pathExtension]];
    //	NSAssert(substitutionFilePath, @"File %@ in substitutionPaths didn't exist", substitutionFileName);
    NSString* substitutionFileName  = [[self stringtoMd5:pathString] retain];
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath]; 
    NSString *substitutionFilePath = [NSString stringWithFormat:@"%@/%@", bundlePath,substitutionFileName];
	
 
    
	//
	// Load the data
	//
	NSData *data = [NSData dataWithContentsOfFile:substitutionFilePath];
	
	//
	// Create the cacheable response
	//
	NSURLResponse *response =   [[[NSURLResponse alloc]
      initWithURL:[request URL]
      MIMEType:[self mimeTypeForPath:pathString]
      expectedContentLength:[data length]
      textEncodingName:nil]
     autorelease];
    
	cachedResponse =[[[NSCachedURLResponse alloc] initWithResponse:response data:data] autorelease];
	
	//
	// Add it to our cache dictionary
	//
	[_cachedResponses setObject:cachedResponse forKey:pathString];
	
	return cachedResponse;
    
    
}
-(void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request{






}
- (void)removeCachedResponseForRequest:(NSURLRequest *)request
{
	//
	// Get the path for the request
	//
	NSString *pathString = [[request URL] path];
	if ([_cachedResponses objectForKey:pathString])
	{
		[_cachedResponses removeObjectForKey:pathString];
	}
	else
	{
		[super removeCachedResponseForRequest:request];
	}
}



@end
