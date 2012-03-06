//
//  RNLocalSubstitutionCache.h
//  html5
//
//  Created by 玉平 孙 on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RNLocalSubstitutionCache : NSURLCache
{
    NSMutableDictionary *_cachedResponses;
}
@end
