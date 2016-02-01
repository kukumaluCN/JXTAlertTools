//
//  JXTAppDelegate.m
//  JXTAlertTools
//
//  Created by JXT on 16/1/27.
//  Copyright © 2016年 JXT. All rights reserved.
//
//  ***
//  *   GitHub:https://github.com/kukumaluCN/JXTAlertTools
//  *   博客:http://www.jianshu.com/users/c8f8558a4b1d/latest_articles
//  *   邮箱:1145049339@qq.com
//  ***
//

#import "JXTAppDelegate.h"

#import "JXTViewController.h"

@interface JXTAppDelegate ()

@end


@implementation JXTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    JXTViewController * rootVC = [[JXTViewController alloc] init];
    UINavigationController * rootNAV = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window.rootViewController = rootNAV;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
