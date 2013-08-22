//
//  ExhibitDetailInfoBean.h
//  CloudBooth
//
//  Created by Ares on 13-8-18.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import "ContentTableViewDataSourceBean.h"

@interface ExhibitDetailInfoBean : ContentTableViewDataSourceBean

// id
@property (nonatomic, retain) NSString *id;

// tag
@property (nonatomic, retain) NSString *tag;

// can collect
@property (nonatomic, readwrite) BOOL canCollect;

// can download
@property (nonatomic, readwrite) BOOL canDownload;

// can exhibit
@property (nonatomic, readwrite) BOOL canExhibit;

// can share
@property (nonatomic, readwrite) BOOL canShare;

// file list
@property (nonatomic, retain) NSArray *fileList;

// tag string
@property (nonatomic, readonly) NSString *tagString;

@end
