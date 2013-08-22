//
//  IContentTableDataSourceRequestProtocol.h
//  CloudBooth
//
//  Created by Ares on 13-8-9.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IContentTableDataSourceRequestProtocol <NSObject>

@optional

// content table data source request url
- (NSURL *)contentTableDataSourceRequestUrl;

// content table data source request param
- (NSDictionary *)contentTableDataSourceRequestParam;

@end
