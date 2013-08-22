//
//  ExhibitFileViewController.h
//  CloudBooth
//
//  Created by Ares on 13-8-19.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExhibitFileViewController : UIViewController <UIWebViewDelegate>

// exhibit session id
@property (nonatomic, retain) NSString *exhibitSessionId;

// exhibit QR image
@property (nonatomic, retain) UIImage *exhibitQRImage;

// exhibit all neighbour file list
@property (nonatomic, retain) NSArray *exhibitAllNeighbourFileList;

// exhibit file index of all neighbour file list
@property (nonatomic, readwrite) NSUInteger exhibitFileIndexOfAllNeighbourFileList;

@end
