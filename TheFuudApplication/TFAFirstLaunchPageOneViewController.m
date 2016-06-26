//
//  TFAFirstLaunchPageOneViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 19/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFAFirstLaunchPageOneViewController.h"

#define IS_IPHONE_4s ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_6 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )
#define IS_IPHONE_6Plus ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )736 ) < DBL_EPSILON )

@interface TFAFirstLaunchPageOneViewController ()

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuudLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextXconstrain;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation TFAFirstLaunchPageOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *fontname = @"";
    NSString *fontTwo = @"";
    NSString *textfont = @"";
    if ([UIFont fontWithName:@".SFUIDisplay-Ultralight" size:10]) {
        fontname = @".SFUIDisplay-Ultralight";
        fontTwo = @".SFUIDisplay-Thin";
        textfont = @".SFUIText-Light";
    }
    else{
        fontTwo = @".HelveticaNeueInterface-Thin";
        fontname = @".HelveticaNeueInterface-UltraLightP2";
        textfont = @".HelveticaNeueInterface-UltraLightP2";
    }
    
    if (IS_IPHONE_4s) {
        self.welcomeLabel.font = [UIFont fontWithName:fontname size:44];
        self.onLabel.font = [UIFont fontWithName:fontname size:44];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:44];
    }
    else if (IS_IPHONE_5){
        self.welcomeLabel.font = [UIFont fontWithName:fontname size:44];
        self.onLabel.font = [UIFont fontWithName:fontname size:44];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:44];
    }
    else if (IS_IPHONE_6){
        self.welcomeLabel.font = [UIFont fontWithName:fontname size:50];
        self.onLabel.font = [UIFont fontWithName:fontname size:50];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:50];
    }
    else{
        self.welcomeLabel.font = [UIFont fontWithName:fontname size:56];
        self.onLabel.font = [UIFont fontWithName:fontname size:56];
        self.fuudLabel.font = [UIFont fontWithName:fontTwo size:56];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adustParallax:)
                                                 name:@"paralax"
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) adustParallax:(NSNotification *) notification{
    CGPoint point = [self.view.superview convertPoint:self.view.frame.origin toView:nil];
    self.xConstrain.constant = point.x;
    self.nextXconstrain.constant = point.x*2;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:1.0 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.nextButton.alpha = 1;
    } completion:nil];
    
}

@end
