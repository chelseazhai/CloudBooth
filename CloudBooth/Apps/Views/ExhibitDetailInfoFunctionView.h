//
//  ExhibitDetailInfoFunctionView.h
//  CloudBooth
//
//  Created by Ares on 13-8-19.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import <UIKit/UIKit.h>

// core location
#import <CoreLocation/CoreLocation.h>

// exhibit detail info object
#import "ExhibitDetailInfoBean.h"

@interface ExhibitDetailInfoFunctionView : UIView <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

// function view width
@property (nonatomic, readonly) CGFloat width;

// exhibit session id
@property (nonatomic, retain) NSString *exhibitSessionId;

// exhibit QR image
@property (nonatomic, retain) UIImage *exhibitQRImage;

// init with exhibit detail info and parent view
- (id)initWithDetailInfo:(ExhibitDetailInfoBean *)detailInfo parentView:(UIView *)parentView;

// force cancel exhibit the document
- (void)forceCancelExhibit;

@end
