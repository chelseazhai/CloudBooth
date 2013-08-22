//
//  ExhibitDetailInfoBean.m
//  CloudBooth
//
//  Created by Ares on 13-8-18.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import "ExhibitDetailInfoBean.h"

@implementation ExhibitDetailInfoBean

+ (id)objectFromJSONData:(NSDictionary *)data thumbnails:(NSDictionary *)thumbnailDictionary
{
    ExhibitDetailInfoBean *_ret = nil;
    
    // check the data
    if (nil != data) {
        _ret = [[ExhibitDetailInfoBean alloc] init];
        
        // set attributes
        [_ret assign:[super objectFromJSONData:data thumbnails:thumbnailDictionary]];
        _ret.tag = [data objectForKey:NSRBGServerFieldString(@"get document detail info request response data key tag", nil)];
        _ret.canDownload = ((NSNumber *)[data objectForKey:NSRBGServerFieldString(@"get document detail info request response data key can download", nil)]).boolValue;
        _ret.canExhibit = ((NSNumber *)[data objectForKey:NSRBGServerFieldString(@"get document detail info request response data key can exhibit", nil)]).boolValue;
        _ret.canShare = ((NSNumber *)[data objectForKey:NSRBGServerFieldString(@"get document detail info request response data key can share", nil)]).boolValue;
    }
    
    return _ret;
}

- (NSString *)tagString
{
    // rebuild tag string for present
    return [_tag stringByReplacingOccurrencesOfString:@"|" withString:@" "];
}

- (NSString *)description
{
    NSMutableString *_description = [[NSMutableString alloc] initWithString:[super description]];
    
    // append class name, title, content, number of been read, thumbnail, document id, tag, operation privilege and file list
    [_description appendFormat:@"\nId = %@", _id];
    [_description appendFormat:@", tag = %@", _tag];
    [_description appendFormat:@", %@ collect", YES == _canCollect ? @"can" : @"can't"];
    [_description appendFormat:@", %@ download", YES == _canDownload ? @"can" : @"can't"];
    [_description appendFormat:@", %@ exhibit", YES == _canExhibit ? @"can" : @"can't"];
    [_description appendFormat:@", %@ share", YES == _canShare ? @"can" : @"can't"];
    [_description appendFormat:@" and file list = %@", _fileList];
    
    return _description;
}

@end
