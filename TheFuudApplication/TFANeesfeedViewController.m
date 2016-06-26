//
//  TFANeesfeedViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 22/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFANeesfeedViewController.h"
#import "AAPLCameraViewController.h"

@interface TFANeesfeedViewController ()

@end

@implementation TFANeesfeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)add:(id)sender {
    AAPLCameraViewController *rootViewController = [[AAPLCameraViewController alloc]initWithNibName:@"AAPLCameraViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    nav.navigationBar.tintColor = [UIColor redColor];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

@end
