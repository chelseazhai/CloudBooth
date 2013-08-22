//
//  TabBarController.h
//  CloudBooth
//
//  Created by Ares on 13-8-9.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import <UIKit/UIKit.h>

// tab content view controllers declaration
@class IndexTableViewController;
@class FavoriteTableViewController;
@class RecentTableViewController;

@interface TabBarController : UITabBarController

// index, favorite and recent tab table view controller
@property (nonatomic, retain) IndexTableViewController *indexTabTableViewController;
@property (nonatomic, retain) FavoriteTableViewController *favoriteTabTableViewController;
@property (nonatomic, retain) RecentTableViewController *recentTabTableViewController;

@end
