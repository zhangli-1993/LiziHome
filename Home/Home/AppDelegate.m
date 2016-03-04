//
//  AppDelegate.m
//  Home
//
//  Created by scjy on 16/3/3.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "SingleViewController.h"
#import "ClassifyViewController.h"
#import "MineViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.tab = [[UITabBarController alloc] init];
    self.tab.tabBar.tintColor = [UIColor colorWithRed:100/255.0f green:199/255.0f blue:250/255.0f alpha:1.0];
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    nav1.tabBarItem.title = @"精选";
    SingleViewController *singVC = [[SingleViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:singVC];
    nav2.tabBarItem.title = @"单品";

    ClassifyViewController *classifyVC = [[ClassifyViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:classifyVC];
    nav3.tabBarItem.title = @"分类";
//    MineViewController *mineVC = [[MineViewController alloc] init];
//    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:mineVC];
    UIStoryboard *mine = [UIStoryboard storyboardWithName:@"MineStoryBoard" bundle:nil];
    UINavigationController *nav4 = mine.instantiateInitialViewController;
    nav4.tabBarItem.title = @"我";
    self.tab.viewControllers = @[nav1, nav2, nav3, nav4];
    self.window.rootViewController = self.tab;

    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
