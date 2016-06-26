//
//  AppDelegate.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 19/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TFAFirstLaunchViewController.h"

@import Firebase;
@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FIRApp configure];
    [FIRDatabase database].persistenceEnabled = YES;
    
    [GMSServices provideAPIKey:@"AIzaSyAJM8DL_kcojdV7JrowXmVreVFJGiMde8M"];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    [FBSDKLoginButton class];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UITabBarController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = rootViewController;
            [self.window makeKeyAndVisible];
        } else {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
            TFAFirstLaunchViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFAFirstLaunchViewController"];
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController = rootViewController;
            [self.window makeKeyAndVisible];
        }
    }];
    
    return YES;
}

-(void)switchToTabBar{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    self.window.rootViewController = rootViewController;

}

-(void)switchToSignUp{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
    TFAFirstLaunchViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFAFirstLaunchViewController"];
    self.window.rootViewController = rootViewController;
    
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    return [[FBSDKApplicationDelegate sharedInstance] application:app
                                                          openURL:url
                                                sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                       annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

@end
