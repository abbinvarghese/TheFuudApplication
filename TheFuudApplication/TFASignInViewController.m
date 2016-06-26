//
//  TFASignInViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 20/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFASignInViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@import Firebase;

@interface TFASignInViewController ()<FBSDKLoginButtonDelegate>

@property (strong, nonatomic) AVPlayer *avplayer;

@property (weak, nonatomic) IBOutlet UIView *playerView;
@property (weak, nonatomic) IBOutlet UIView *gradientView;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *noAccountButton;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookButton;


@end

@implementation TFASignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.facebookButton.delegate = self;
    self.facebookButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    [self initVideoBackground];
    
    int height = [UIScreen mainScreen].bounds.size.height/2;
    int width = (height*9)/16;
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-width+width/4, [UIScreen mainScreen].bounds.size.height/16, width, height)];
    imageview.backgroundColor = [UIColor lightTextColor];
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: imageview.bounds byRoundingCorners: UIRectCornerAllCorners cornerRadii: (CGSize){10.0, 10.0}].CGPath;
    imageview.layer.mask = maskLayer;
    [self.view addSubview:imageview];
    
    NSString *fontname = @"";
    NSString *fontTwo = @"";
    if ([UIFont fontWithName:@".SFUIDisplay-Thin" size:10]) {
        fontname = @".SFUIDisplay-Thin";
        fontTwo = @".SFUIDisplay-Light";
    }
    else{
        fontTwo = @".HelveticaNeueInterface-Thin";
        fontname = @".HelveticaNeueInterface-UltraLightP2";
    }
    
    NSString *string = @"Join FUUD\nWe won't post anything without your permission. Pinky promise :)";
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:string];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/18]
                  range:NSMakeRange(0, string.length)];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:fontTwo size:[UIScreen mainScreen].bounds.size.width/16]
                  range:NSMakeRange(5, 5)];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/25]
                  range:NSMakeRange(10, 64)];
    
    self.noAccountButton.titleLabel.font = [UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/25];
    self.textLabel.attributedText = hogan;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.avplayer pause];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.avplayer play];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Background Video Methods -


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


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Facebook Methods -

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error == nil && [FBSDKAccessToken currentAccessToken]
        .tokenString) {
        self.view.userInteractionEnabled = NO;
        [_activityIndicator startAnimating];
        FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                         credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                         .tokenString];
        
        [[FIRAuth auth].currentUser linkWithCredential:credential
                                            completion:^(FIRUser *_Nullable user,
                                                         NSError *_Nullable error) {
                                                if (error == nil) {
                                                    [_activityIndicator stopAnimating];
                                                    self.view.userInteractionEnabled = YES;
                                                    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
                                                    NSDictionary *post = @{userIDKey: user.uid,
                                                                           userIsAnonymousKey:[NSNumber numberWithBool:user.isAnonymous]};
                                                    
                                                    NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/%@/%@",userPathKey,user.uid]:post};
                                                    
                                                    [ref updateChildValues:childUpdates];
                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                }
                                                else if(error.code == 17025){
                                                    [[FIRAuth auth] signInWithCredential:credential
                                                                              completion:^(FIRUser *user, NSError *error) {
                                                                                  [_activityIndicator stopAnimating];
                                                                                  self.view.userInteractionEnabled = YES;
                                                                                  if (error == nil) {
                                                                                      FIRDatabaseReference *ref = [[FIRDatabase database] reference];
                                                                                      NSDictionary *post = @{userIDKey: user.uid,
                                                                                                             userIsAnonymousKey:[NSNumber numberWithBool:user.isAnonymous]};
                                                                                      NSDictionary *childUpdates = @{[@"/users/" stringByAppendingString:user.uid]: post};
                                                                                      [ref updateChildValues:childUpdates];
                                                                                      [self dismissViewControllerAnimated:YES completion:nil];
                                                                                  }
                                                                              }];
                                                }
                                            }];
        
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Actions -


- (IBAction)noAccountNeeded:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
