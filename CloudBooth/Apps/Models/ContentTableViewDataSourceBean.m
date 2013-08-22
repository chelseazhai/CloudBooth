//
//  ContentTableViewDataSourceBean.m
//  CloudBooth
//
//  Created by Ares on 13-8-13.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import "ContentTableViewDataSourceBean.h"

@implementation ContentTableViewDataSourceBean

+ (id)objectFromJSONData:(NSDictionary *)data thumbnails:(NSDictionary *)thumbnailDictionary
{
    ContentTableViewDataSourceBean *_ret = nil;
    
    // check the data
    if (nil != data) {
        _ret = [[ContentTableViewDataSourceBean alloc] init];
        
        // get thumbnail from thumbnail dictionary
        id _thumbnail = nil == thumbnailDictionary ? nil : [thumbnailDictionary objectForKey:[data objectForKey:NSRBGServerFieldString(@"get document, favorite, recent shared list and document detail info request response data key thumbnail url", nil)]];
        
        // set attributes
        _ret.title = [data objectForKey:NSRBGServerFieldString(@"get document, favorite, recent shared list and document detail info request response data key title", nil)];
        _ret.content = [data objectForKey:NSRBGServerFieldString(@"get document, favorite, recent shared list and document detail info request response data key content", nil)];
        _ret.numberOfBeenRead = ((NSNumber *)[data objectForKey:NSRBGServerFieldString(@"get document, favorite and recent shared list request response data key number of been read", nil)]).unsignedIntegerValue;
        _ret.thumbnail = nil != _thumbnail && [_thumbnail isMemberOfClass:[UIImage class]] ? _thumbnail : [UIImage imageNamed:@"img_default_thumbnail"];
    }
    
    return _ret;
}

- (id)assign:(ContentTableViewDataSourceBean *)assignedBean
{
    // check self
    if (nil != self) {
        // assign its attributes
        _title = assignedBean.title;
        _content = assignedBean.content;
        _numberOfBeenRead = assignedBean.numberOfBeenRead;
        _thumbnail = assignedBean.thumbnail;
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString *_description = [[NSMutableString alloc] init];
    
    // append class name, title, content, number of been read and thumbnail
    [_description appendFormat:@"Object class = %@", NSStringFromClass(self.class)];
    [_description appendFormat:@", title = %@", _title];
    [_description appendFormat:@", content = %@", _content];
    [_description appendFormat:@", number of been read = %d", _numberOfBeenRead];
    [_description appendFormat:@" and thumbnail = %@", _thumbnail];
    
    return _description;
}

@end
