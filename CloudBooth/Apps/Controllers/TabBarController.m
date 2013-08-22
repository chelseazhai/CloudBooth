//
//  TabBarController.m
//  CloudBooth
//
//  Created by Ares on 13-8-9.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import "TabBarController.h"

// index, favorite and recent tab table view controller
#import "IndexTableViewController.h"
#import "FavoriteTableViewController.h"
#import "RecentTableViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init index, favorite and recent tab table view controller
        _indexTabTableViewController = [[IndexTableViewController alloc] init];
        _favoriteTabTableViewController = [[FavoriteTableViewController alloc] init];
        _recentTabTableViewController = [[RecentTableViewController alloc] init];
        
        // set tab bar controller's view controllers
        self.viewControllers = @[[[UINavigationController alloc] initWithRootViewController:_indexTabTableViewController], [[UINavigationController alloc] initWithRootViewController:_favoriteTabTableViewController], [[UINavigationController alloc] initWithRootViewController:_recentTabTableViewController]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
