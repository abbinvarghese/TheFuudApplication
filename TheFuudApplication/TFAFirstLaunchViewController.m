//
//  TFAFirstLaunchViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 19/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFAFirstLaunchViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TFAFirstLaunchPageOneViewController.h"
#import "TFAFirstLaunchPageFourViewController.h"
#import "TFAFirstLaunchPageTwoViewController.h"
#import "TFAFirstLaunchPageThreeViewController.h"
#import "TFAFirstLaunchPageFiveViewController.h"

@interface TFAFirstLaunchViewController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) AVPlayer *avplayer;

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation TFAFirstLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initVideoBackground];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TFAPageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
    TFAFirstLaunchPageOneViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFAFirstLaunchPageOneViewController"];
    NSArray *viewControllers = @[rootViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = self.view.frame;
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    for (UIView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setDelegate:self];
        }
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //  CGFloat percentage = scrollView.contentOffset.x;
    //  NSDictionary* userInfo = @{@"adustment": @(percentage)};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"paralax" object:self userInfo:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.avplayer pause];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.avplayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[TFAFirstLaunchPageOneViewController class]]) {
        return nil;
    }
    else if ([viewController isKindOfClass:[TFAFirstLaunchPageTwoViewController class]]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
        TFAFirstLaunchPageOneViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFAFirstLaunchPageOneViewController"];
        return rootViewController;
    }
    else if ([viewController isKindOfClass:[TFAFirstLaunchPageThreeViewController class]]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
        TFAFirstLaunchPageTwoViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFAFirstLaunchPageTwoViewController"];
        return rootViewController;
    }
    else if ([viewController isKindOfClass:[TFAFirstLaunchPageFourViewController class]]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
        TFAFirstLaunchPageThreeViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFAFirstLaunchPageThreeViewController"];
        return rootViewController;
    }
    else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
        TFAFirstLaunchPageFourViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFAFirstLaunchPageFourViewController"];
        return rootViewController;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[TFAFirstLaunchPageOneViewController class]]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
        TFAFirstLaunchPageTwoViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFAFirstLaunchPageTwoViewController"];
        return rootViewController;
    }
    else if ([viewController isKindOfClass:[TFAFirstLaunchPageTwoViewController class]]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
        TFAFirstLaunchPageThreeViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFAFirstLaunchPageThreeViewController"];
        return rootViewController;
    }
    else if ([viewController isKindOfClass:[TFAFirstLaunchPageThreeViewController class]]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
        TFAFirstLaunchPageFourViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFAFirstLaunchPageFourViewController"];
        return rootViewController;
    }
    else if ([viewController isKindOfClass:[TFAFirstLaunchPageFourViewController class]]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
        TFAFirstLaunchPageFiveViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"TFAFirstLaunchPageFiveViewController"];
        return rootViewController;
    }
    else{
        return nil;
    }
}


- (void)initVideoBackground{
    
    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    
    //Set up player
    NSURL *movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"IMG_0101" ofType:@"mp4"]];
    AVAsset *avAsset = [AVAsset assetWithURL:movieURL];
    AVPlayerItem *avPlayerItem =[[AVPlayerItem alloc]initWithAsset:avAsset];
    self.avplayer = [[AVPlayer alloc]initWithPlayerItem:avPlayerItem];
    AVPlayerLayer *avPlayerLayer =[AVPlayerLayer playerLayerWithPlayer:self.avplayer];
    [avPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [avPlayerLayer setFrame:[[UIScreen mainScreen] bounds]];
    [self.playerView.layer addSublayer:avPlayerLayer];
    //Config player
    [self.avplayer seekToTime:kCMTimeZero];
    [self.avplayer setVolume:0.0f];
    [self.avplayer setActionAtItemEnd:AVPlayerActionAtItemEndNone];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.avplayer currentItem]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerStartPlaying)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [[UIScreen mainScreen] bounds];
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithWhite:0 alpha:0.2].CGColor,(id)[UIColor colorWithWhite:0 alpha:1].CGColor,nil];
    [self.gradientView.layer insertSublayer:gradient atIndex:0];
}

- (void)playerStartPlaying{
    
    [self.avplayer play];
    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    
}


@end
