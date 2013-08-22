//
//  AppDelegate.h
//  CloudBooth
//
//  Created by Ares on 13-8-9.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import <UIKit/UIKit.h>

// tab bar controller declaration
@class TabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TabBarController *tabBarController;

@end
