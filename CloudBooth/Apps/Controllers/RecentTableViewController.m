//
//  RecentTableViewController.m
//  CloudBooth
//
//  Created by Ares on 13-8-9.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import "RecentTableViewController.h"

@interface RecentTableViewController ()

@end

@implementation RecentTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // set recent tab content navigation bar title
        self.title = NSLocalizedString(@"recent tab content table view controller nav title", nil);
        
        // set recent tab content tab bar item attributes
        self.tabBarItem.title = NSLocalizedString(@"recent tab bar item title", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"img_recentTab"];
        self.tabBarItem.tag = 2;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Content table data source request protocol

- (NSDictionary *)contentTableDataSourceRequestParam
{
    // define recent table view data source request param dictionary
    NSMutableDictionary *_paramDic = [[NSMutableDictionary alloc] init];
    
    // set param key and value
    [_paramDic setObject:NSRBGServerFieldString(@"get recent shared list post http request", nil) forKey:NSRBGServerFieldString(@"post http request param key action", nil)];
    [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key user id", nil)];
    [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key company id", nil)];
    [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"get recent shared list post http request param key last tag", nil)];
    
    return _paramDic;
}

@end
