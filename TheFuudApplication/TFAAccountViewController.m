//
//  TFAAccountViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 20/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFAAccountViewController.h"
#import "TFASignInViewController.h"
#import "AppDelegate.h"
#import "TFAFeedbackViewController.h"
#import "TFAEditProfileViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@import Firebase;

#define YOUR_APP_STORE_ID 284882215 //Change this one to your ID
static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";

@interface TFAAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *accountTableview;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation TFAAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _profileImageview.layer.cornerRadius = _profileImageview.frame.size.height/2;
    _profileImageview.layer.masksToBounds = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[FIRAuth auth] addAuthStateDidChangeListener:^(FIRAuth *_Nonnull auth,
                                                    FIRUser *_Nullable user) {
        if (user != nil && !user.isAnonymous){
            for (id<FIRUserInfo> profile in user.providerData) {
                NSString *name = profile.displayName;
                NSURL *photoURL = profile.photoURL;
                [_profileImageview sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"Profile Placeholder"]];
                _nameLabel.text = name;
            }
        }else {
            _nameLabel.text = @"No User signed in";
        }
    }];
    [_accountTableview reloadData];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UITableView DataSource -


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([FIRAuth auth].currentUser.isAnonymous) {
        return 4;
    }
    else{
        return 7;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountCell"];
    switch (indexPath.row) {
        case 0:{
            if ([FIRAuth auth].currentUser.isAnonymous) {
                cell.imageView.image = [UIImage imageNamed:@"Sign In"];
                cell.textLabel.text = @"Sign In";
                return cell;
            }
            else{
                cell.imageView.image = [UIImage imageNamed:@"Edit profile"];
                cell.textLabel.text = @"Edit profile";
                return cell;
            }
        }
            break;
        case 1:{
            if ([FIRAuth auth].currentUser.isAnonymous) {
                cell.imageView.image = [UIImage imageNamed:@"Appstore"];
                cell.textLabel.text = @"Rate us on the AppStore";
                return cell;
            }
            else{
                cell.imageView.image = [UIImage imageNamed:@"Firends list"];
                cell.textLabel.text = @"Firends list";
                return cell;
            }
        }
            break;
            
        case 2:{
            if ([FIRAuth auth].currentUser.isAnonymous) {
                cell.imageView.image = [UIImage imageNamed:@"FeedBack"];
                cell.textLabel.text = @"Send us a feedback";
                return cell;
            }
            else{
                cell.imageView.image = [UIImage imageNamed:@"Find Friends"];
                cell.textLabel.text = @"Find new friends";
                return cell;
            }
        }
            break;
        case 3:{
            if ([FIRAuth auth].currentUser.isAnonymous) {
                cell.imageView.image = [UIImage imageNamed:@"About"];
                cell.textLabel.text = @"About";
                return cell;
            }
            else{
                cell.imageView.image = [UIImage imageNamed:@"Appstore"];
                cell.textLabel.text = @"Rate us on the AppStore";
                return cell;
            }
        }
            break;
        case 4:{
            cell.imageView.image = [UIImage imageNamed:@"FeedBack"];
            cell.textLabel.text = @"Send us a feedback";
            return cell;
        }
            break;
        case 5:{
            cell.imageView.image = [UIImage imageNamed:@"About"];
            cell.textLabel.text = @"About";
            return cell;
        }
            break;
        case 6:{
            cell.imageView.image = [UIImage imageNamed:@"Sign out"];
            cell.textLabel.text = @"Sign out";
            return cell;
        }
            break;
            
        default:
            return cell;
            break;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UITableView Delegate -


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            if ([FIRAuth auth].currentUser.isAnonymous) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
                TFASignInViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TFASignInViewController"];
                [self presentViewController:vc animated:YES completion:nil];
            }
            else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                TFAEditProfileViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TFAEditProfileViewController"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 1:{
            if ([FIRAuth auth].currentUser.isAnonymous) {
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:iOS7AppStoreURLFormat, YOUR_APP_STORE_ID]];
                [[UIApplication sharedApplication] openURL:url];
            }
            else{
                
            }
        }
            break;
        case 2:{
            if ([FIRAuth auth].currentUser.isAnonymous) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TFAFeedbackViewController"];
                [self presentViewController:vc animated:YES completion:nil];
            }
            else{
                
            }
        }
            break;
        case 3:{
            if ([FIRAuth auth].currentUser.isAnonymous) {
                
            }
            else{
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:iOS7AppStoreURLFormat, YOUR_APP_STORE_ID]];
                [[UIApplication sharedApplication] openURL:url];
            }
        }
            break;
        case 4:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TFAFeedbackViewController"];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 5:{
            
        }
            break;
        case 6:{
            [self signOut];
        }
            break;
            
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Actions -

-(void)signOut{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"Sign out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSError *error;
        [[FBSDKLoginManager new] logOut];
        [[FIRAuth auth] signOut:&error];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate switchToSignUp];
    }];
    UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:actionYes];
    [alert addAction:actionNo];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
