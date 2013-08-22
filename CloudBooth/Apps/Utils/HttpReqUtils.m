//
//  HttpReqUtils.m
//  CloudBooth
//
//  Created by Ares on 13-8-18.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import "HttpReqUtils.h"

@implementation HttpReqUtils

+ (NSMutableURLRequest *)genAsyncPostHttpRequest:(NSURL *)requestUrl postParam:(NSDictionary *)postParam
{
    // define the request
    NSMutableURLRequest *_request = [[NSMutableURLRequest alloc] initWithURL:requestUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    // set request method
    _request.HTTPMethod = @"POST";
    
    // generate http request param
    NSMutableString *_paramString = [[NSMutableString alloc] init];
    if (nil != postParam) {
        // get all keys array and count
        NSArray *_allKeys = postParam.allKeys;
        NSUInteger _allKeysCount = [_allKeys count];
        
        for (int _index = 0; _index < _allKeysCount;) {
            // get key
            NSString *_key = [_allKeys objectAtIndex:_index++];
            
            // set param string
            [_paramString appendFormat:@"%@=%@", _key, [postParam objectForKey:_key]];
            if (_allKeysCount != _index) {
                [_paramString appendString:@"&"];
            }
        }
    }
    
    // set request body
    _request.HTTPBody = [_paramString dataUsingEncoding:NSUTF8StringEncoding];
    
    return _request;
}

@end
