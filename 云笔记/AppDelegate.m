//
//  AppDelegate.m
//  云笔记
//
//  Created by 079 on 14-11-26.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import "AppDelegate.h"
#import "TextNoteListViewController.h"
#import "PicNoteListViewController.h"
#import "LogViewController.h"
#import "AddPicNoteViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TextNoteListViewController *textnoteListViewController = [[TextNoteListViewController alloc]initWithNibName:@"TextNoteListViewController" bundle:nil];
    UINavigationController *textnoteListNavigationController = [[UINavigationController alloc]initWithRootViewController:textnoteListViewController];
    
    PicNoteListViewController *picnoteListViewController = [[PicNoteListViewController alloc]initWithNibName:@"PicNoteListViewController" bundle:nil];
    UINavigationController *picnoteListNavigationController = [[UINavigationController alloc]initWithRootViewController:picnoteListViewController];
    
    LogViewController *logViewController = [[LogViewController alloc]initWithNibName:@"LogViewController" bundle:nil];
    UINavigationController *logNavigationController = [[UINavigationController alloc]initWithRootViewController:logViewController];
    
    AddPicNoteViewController *addpicnoteViewController = [[AddPicNoteViewController alloc]initWithNibName:@"AddPicNoteViewController" bundle:nil];
    UINavigationController *addpicnoteNavigationController = [[UINavigationController alloc]initWithRootViewController:addpicnoteViewController];
    
    UITabBarController *tabbarController = [[UITabBarController alloc]init];
    tabbarController.viewControllers = [NSArray arrayWithObjects:picnoteListNavigationController,logNavigationController,addpicnoteNavigationController,textnoteListNavigationController, nil];
    
    tabbarController.delegate = self;
    tabbarController.selectedIndex = 1;
    
    //[tabbarController.tabBar setBackgroundImage:[UIImage imageNamed:@"0.gif"]];
    [tabbarController.tabBar setBackgroundColor:[UIColor blueColor]];
    
    self.window.rootViewController = tabbarController;
    
    self.flag = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginsuccess) name:@"loginsuccess" object:nil];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)loginsuccess {
    self.flag = YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return self.flag;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    /*CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    
    [[self.window layer]addAnimation:animation forKey:@"animation"];*/
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
