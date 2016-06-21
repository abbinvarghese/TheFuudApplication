//
//  TFAFirstLaunchPageFiveViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 19/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFAFirstLaunchPageFiveViewController.h"
#import "AppDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@import Firebase;

@interface TFAFirstLaunchPageFiveViewController ()<FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xConstrain;
@property (weak, nonatomic) IBOutlet UIButton *noAccountButton;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation TFAFirstLaunchPageFiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.facebookButton.delegate = self;
    self.facebookButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    int height = [UIScreen mainScreen].bounds.size.height/2;
    int width = (height*9)/16;
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-width+width/4,
                                                                          [UIScreen mainScreen].bounds.size.height/16,
                                                                          width,
                                                                          height)];
    imageview.backgroundColor = [UIColor lightTextColor];
    
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: imageview.bounds byRoundingCorners: UIRectCornerAllCorners cornerRadii: (CGSize){10.0, 10.0}].CGPath;
    
    imageview.layer.mask = maskLayer;
    
    [self.view addSubview:imageview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adustParallax:)
                                                 name:@"paralax"
                                               object:nil];
    
    
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

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error == nil && [FBSDKAccessToken currentAccessToken]
        .tokenString) {
        self.view.userInteractionEnabled = NO;
        [_activityIndicator startAnimating];
        FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                         credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                         .tokenString];
        [[FIRAuth auth] signInWithCredential:credential
                                  completion:^(FIRUser *user, NSError *error) {
                                      [_activityIndicator stopAnimating];
                                      self.view.userInteractionEnabled = YES;
                                      if (error == nil) {
                                          FIRDatabaseReference *ref = [[FIRDatabase database] reference];
                                          NSString *key = [[ref child:userPath] childByAutoId].key;
                                          NSDictionary *post = @{userIDKey: user.uid,
                                                                 isAnonymousKey:[NSNumber numberWithBool:user.isAnonymous]};
                                          NSDictionary *childUpdates = @{[@"/users/" stringByAppendingString:key]: post};
                                          [ref updateChildValues:childUpdates];
                                          AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                          [appDelegate switchToTabBar];
                                      }
                                  }];
        
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}

- (void) adustParallax:(NSNotification *) notification{
    CGPoint point = [self.view.superview convertPoint:self.view.frame.origin toView:nil];
    self.xConstrain.constant = point.x;
}

- (IBAction)noAccountNeeded:(UIButton *)sender {
    [_activityIndicator startAnimating];
    self.view.userInteractionEnabled = NO;
    [[FIRAuth auth]
     signInAnonymouslyWithCompletion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
         [_activityIndicator stopAnimating];
         self.view.userInteractionEnabled = YES;
         if (error == nil) {
             FIRDatabaseReference *ref = [[FIRDatabase database] reference];
             NSDictionary *post = @{userIDKey: user.uid,
                                    isAnonymousKey:[NSNumber numberWithBool:user.isAnonymous]};
             NSDictionary *childUpdates = @{[@"/users/" stringByAppendingString:user.uid]: post};
             [ref updateChildValues:childUpdates];
             AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [appDelegate switchToTabBar];
         }
     }];
}


@end
