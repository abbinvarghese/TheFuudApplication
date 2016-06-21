//
//  TFAFirstLaunchPageThreeViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 19/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFAFirstLaunchPageThreeViewController.h"

@interface TFAFirstLaunchPageThreeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *xConstrain;

@end

@implementation TFAFirstLaunchPageThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    int height = [UIScreen mainScreen].bounds.size.height/2;
    int width = (height*250)/667;
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                          [UIScreen mainScreen].bounds.size.height/8,
                                                                          width,
                                                                          height)];
    imageview.backgroundColor = [UIColor lightTextColor];
    
    
    CAShapeLayer * maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect: imageview.bounds byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: (CGSize){10.0, 10.0}].CGPath;
    
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
    
    NSString *string = @"Found something new?\nDont eat alone.\nLet the others know.\nFUUD is always best shared";
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:string];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:fontname size:[UIScreen mainScreen].bounds.size.width/18]
                  range:NSMakeRange(0, string.length)];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:fontTwo size:[UIScreen mainScreen].bounds.size.width/16]
                  range:NSMakeRange(16, 3)];
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:fontTwo size:[UIScreen mainScreen].bounds.size.width/16]
                  range:NSMakeRange(58, 4)];
    
    self.textLabel.attributedText = hogan;

    // Do any additional setup after loading the view.
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
