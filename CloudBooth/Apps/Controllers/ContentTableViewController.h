//
//  ContentTableViewController.h
//  CloudBooth
//
//  Created by Ares on 13-8-9.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import <UIKit/UIKit.h>

// content table data source request protocol
#import "IContentTableDataSourceRequestProtocol.h"

@interface ContentTableViewController : UITableViewController <IContentTableDataSourceRequestProtocol>

@end
