//
//  TFAFirstLaunchPageFourViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 19/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFAFirstLaunchPageFourViewController.h"

@interface TFAFirstLaunchPageFourViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xConstrain;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation TFAFirstLaunchPageFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int height = [UIScreen mainScreen].bounds.size.height/2;
    int width = (height*9)/16;
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-width/2,
                                                                          -10,
                                                                          width,
                                                                          height)];
    imageview.backgroundColor = [UIColor lightTextColor];
    
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: imageview.bounds byRoundingCorners: UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii: (CGSize){10.0, 10.0}].CGPath;
    
    imageview.layer.mask = maskLayer;
    
    [self.view addSubview:imageview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adustParallax:)
                                                 name:@"paralax"
                                               object:nil];
    NSString *fontname = @"";
    NSString *fontTwo = @"";
    NSString *textfont = @"";
    if ([UIFont fontWithName:@".SFUIDisplay-Thin" size:10]) {
        fontname = @".SFUIDisplay-Thin";
        fontTwo = @".SFUIDisplay-Light";
        textfont = @".SFUIText-Light";
    }
    else{
        fontTwo = @".HelveticaNeueInterface-Thin";
        fontname = @".HelveticaNeueInterface-UltraLightP2";
        textfont = @".HelveticaNeueInterface-UltraLightP2";
    }
    
    NSString *string = @"Connect with Friends and know what they have been up to.\nNewsfeed!";
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:string];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/18]
                  range:NSMakeRange(0, string.length)];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:fontTwo size:[UIScreen mainScreen].bounds.size.width/16]
                  range:NSMakeRange(13, 7)];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:fontTwo size:[UIScreen mainScreen].bounds.size.width/16]
                  range:NSMakeRange(57, 9)];
    
    self.textLabel.attributedText = hogan;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) adustParallax:(NSNotification *) notification{
    CGPoint point = [self.view.superview convertPoint:self.view.frame.origin toView:nil];
    self.xConstrain.constant = point.x;
}

@end
