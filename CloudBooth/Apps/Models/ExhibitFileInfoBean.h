//
//  ExhibitFileInfoBean.h
//  CloudBooth
//
//  Created by Ares on 13-8-19.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExhibitFileInfoBean : NSObject

// type
@property (nonatomic, retain) NSString *type;

// name
@property (nonatomic, retain) NSString *name;

// number of images
@property (nonatomic, readwrite) NSUInteger numberOfImages;

// file type icon
@property (nonatomic, readonly) UIImage *fileTypeIcon;

// is video media file
@property (nonatomic, readonly) BOOL isVideoMediaFile;

// exhibit file info bean from json object
+ (id)objectFromJSONData:(NSDictionary *)data;

@end
