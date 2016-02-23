//
//  AppDelegate.m
//  Demo-MusicPlayer
//
//  Created by Strom on 16/1/7.
//  Copyright © 2016年 Strom. All rights reserved.
//

#import "AppDelegate.h"
#import "KNCurrentPlayControl.h"
#import "KNOnlieMusicControl.h"
#import "KNGroupControl.h"
#import "KNSettingContro.h"
#import "UIColor+Art.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
   //    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
//    
//    UINavigationController *myMusic=[[UINavigationController alloc] initWithRootViewController:[[KNGroupControl alloc] init]];
//    
//    UINavigationController *playMuisc=[[UINavigationController alloc] initWithRootViewController:[[KNOnlieMusicControl alloc] init]];
//    
//    UINavigationController *setMusic=[[UINavigationController alloc] initWithRootViewController:[[KNSettingContro alloc] init]];
//    
//    UITabBarController *tab=[[UITabBarController alloc] init];
//    
//    tab.viewControllers=@[myMusic,playMuisc,setMusic];
//    self.window.rootViewController=tab;
//    [self.window makeKeyAndVisible];
    
    // Tabbar
    UIEdgeInsets standardEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"clear.png"]];
    
    UIImage * backgroundForTabBar = [[UIImage imageNamed:@"tabbar_back.png"] resizableImageWithCapInsets:standardEdgeInsets
                                                                                            resizingMode:UIImageResizingModeStretch];
    [[UITabBar appearance] setBackgroundImage:backgroundForTabBar];
    
    UIImage * backgroundForSelectedTabBarItem = [[UIImage imageNamed:@"tabbar_selected_back.png"] resizableImageWithCapInsets:standardEdgeInsets
                                                                                                                 resizingMode:UIImageResizingModeStretch];
    [[UITabBar appearance] setSelectionIndicatorImage:backgroundForSelectedTabBarItem];
    
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -2)];
   // [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor colorWithHex:0x999999] }
                                          //   forState:UIControlStateNormal];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    
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
