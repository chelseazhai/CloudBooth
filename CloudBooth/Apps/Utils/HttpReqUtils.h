//
//  HttpReqUtils.h
//  CloudBooth
//
//  Created by Ares on 13-8-18.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpReqUtils : NSObject

// generate asynchronous post http request
+ (NSMutableURLRequest *)genAsyncPostHttpRequest:(NSURL *)requestUrl postParam:(NSDictionary *)postParam;

@end
