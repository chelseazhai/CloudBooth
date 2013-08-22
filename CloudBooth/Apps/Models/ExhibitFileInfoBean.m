//
//  ExhibitFileInfoBean.m
//  CloudBooth
//
//  Created by Ares on 13-8-19.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import "ExhibitFileInfoBean.h"

@implementation ExhibitFileInfoBean

+ (id)objectFromJSONData:(NSDictionary *)data
{
    ExhibitFileInfoBean *_ret = nil;
    
    // check the data
    if (nil != data) {
        _ret = [[ExhibitFileInfoBean alloc] init];
        
        // get file suffix
        NSString *_fileSuffix = [data objectForKey:NSRBGServerFieldString(@"get document detail info file list request response data key file suffix", nil)];
        
        // set attributes
        _ret.type = nil != _fileSuffix ? _fileSuffix : [data objectForKey:NSRBGServerFieldString(@"get document detail info file image request response data key file type", nil)];
        _ret.name = [data objectForKey:NSRBGServerFieldString(@"get document detail info file list request response data key file name", nil)];
        _ret.numberOfImages = ((NSString *)[data objectForKey:NSRBGServerFieldString(@"get document detail info file image request response data key number of images", nil)]).integerValue;
    }
    
    return _ret;
}

- (UIImage *)fileTypeIcon
{
    NSString *_retImgName = nil;
    
    // check file type
    if (NSNotFound != [NSRBGServerFieldString(@"document detail info picture file suffixes", nil) rangeOfString:_type].location) {
        _retImgName = @"img_picture";
    }
    else if (NSNotFound != [NSRBGServerFieldString(@"document detail info office doc file suffixes", nil) rangeOfString:_type].location) {
        _retImgName = @"img_office_doc";
    }
    else if (NSNotFound != [NSRBGServerFieldString(@"document detail info office ppt file suffixes", nil) rangeOfString:_type].location) {
        _retImgName = @"img_office_ppt";
    }
    else if (NSNotFound != [NSRBGServerFieldString(@"document detail info video media file suffixes", nil) rangeOfString:_type].location) {
        _retImgName = @"img_video_media";
    }
    
    return [UIImage imageNamed:_retImgName];
}

- (BOOL)isVideoMediaFile
{
    BOOL _ret = NO;
    
    // check file type
    if (NSNotFound != [NSRBGServerFieldString(@"document detail info video media file suffixes", nil) rangeOfString:_type].location) {
        _ret = YES;
    }
    
    return _ret;
}

- (NSString *)description
{
    NSMutableString *_description = [[NSMutableString alloc] init];
    
    // append class name, type, name and number of images
    [_description appendFormat:@"Object class = %@", NSStringFromClass(self.class)];
    [_description appendFormat:@", type = %@", _type];
    [_description appendFormat:@", name = %@", _name];
    [_description appendFormat:@" and number of images = %d", _numberOfImages];
    
    return _description;
}

@end
