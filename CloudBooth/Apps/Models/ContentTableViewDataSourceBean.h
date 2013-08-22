//
//  ContentTableViewDataSourceBean.h
//  CloudBooth
//
//  Created by Ares on 13-8-13.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentTableViewDataSourceBean : NSObject

// title
@property (nonatomic, retain) NSString *title;

// content
@property (nonatomic, retain) NSString *content;

// number of been read
@property (nonatomic, readwrite) NSUInteger numberOfBeenRead;

// thumbnail
@property (nonatomic, retain) UIImage *thumbnail;

// content table view data source bean from json object with thumbnail dictionary
+ (id)objectFromJSONData:(NSDictionary *)data thumbnails:(NSDictionary *)thumbnailDictionary;

// assign
- (id)assign:(ContentTableViewDataSourceBean *)assignedBean;

@end
