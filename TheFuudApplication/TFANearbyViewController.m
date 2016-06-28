//
//  TFANearbyViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 22/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFANearbyViewController.h"

@interface TFANearbyViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UITableView *nearByTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingSpaceConstrain;
@property (nonatomic) CGFloat previousScrollViewYOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationViewTopconstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sortViewTopconstrain;
@property (weak, nonatomic) IBOutlet UIView *sortView;

@end

@implementation TFANearbyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, 43.0, self.view.frame.size.width, 0.3f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.0f
                                                     alpha:0.3f].CGColor;
    [_navigationView.layer addSublayer:bottomBorder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UITableView DataSource -

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    return cell;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UITableView Delegate -

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return (tableView.frame.size.width* 8/15)+100;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 6.0;
    }
    
    return 1.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UIScrollView Delegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = self.navigationView.frame;
    CGFloat size = frame.size.height - 21;
    CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
    
    if (scrollOffset <= -scrollView.contentInset.top) {
        frame.origin.y = 20;
        [UIView animateWithDuration:0.5 animations:^{
            self.navigationViewTopconstrain.constant = frame.origin.y;
            self.sortViewTopconstrain.constant = frame.origin.y-22;
            [self.view layoutIfNeeded];
        }];
        [self updateBarButtonItems:(1 - framePercentageHidden)];
        self.previousScrollViewYOffset = scrollOffset;
        
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
        frame.origin.y = -size;
        self.navigationViewTopconstrain.constant = frame.origin.y;
        self.sortViewTopconstrain.constant = frame.origin.y-22;
        [self updateBarButtonItems:(1 - framePercentageHidden)];
        self.previousScrollViewYOffset = scrollOffset;
    } else {
        frame.origin.y = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
        self.navigationViewTopconstrain.constant = frame.origin.y;
        self.sortViewTopconstrain.constant = frame.origin.y-22;
        [self updateBarButtonItems:(1 - framePercentageHidden)];
        self.previousScrollViewYOffset = scrollOffset;
    }
    

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Actions -

- (IBAction)hotClicked:(UIButton *)sender {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.leadingSpaceConstrain.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)freshClicked:(UIButton *)sender {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.leadingSpaceConstrain.constant = sender.frame.size.width;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Utility Methods -

- (void)stoppedScrolling
{
    CGRect frame = self.navigationView.frame;
    if (frame.origin.y < 20) {
        [self animateNavBarTo:-(frame.size.height - 21)];
    }
}

- (void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    self.navigationItem.titleView.alpha = alpha;
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

- (void)animateNavBarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.navigationView.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        self.navigationViewTopconstrain.constant = frame.origin.y;
        self.sortViewTopconstrain.constant = frame.origin.y-22;
        [self.view layoutIfNeeded];
        [self updateBarButtonItems:alpha];
    }];
}
@end
