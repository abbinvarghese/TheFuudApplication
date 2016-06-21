//
//  TFAAccountViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 20/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFAAccountViewController.h"
#import "TFAAccountTableViewCell.h"
#import "TFASignInViewController.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import Firebase;

#define YOUR_APP_STORE_ID 284882215 //Change this one to your ID
static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";

typedef NS_ENUM(NSInteger, TableViewSection) {
    ProfileSection,
    ConnectSection,
    OthersSection,
    SignOutSection
};

typedef NS_ENUM(NSInteger, ProfileRow) {
    FindFriendsListRow
};

typedef NS_ENUM(NSInteger, OthersRow) {
    AppstoreRow,
    FeedbackRow,
    AboutRow,
};

typedef NS_ENUM(NSInteger, SignOut) {
    SignOutRow
};

@interface TFAAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *accountTableview;

@end

@implementation TFAAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_accountTableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([FIRAuth auth].currentUser.isAnonymous) {
        return 3;
    }
    else{
        return 4;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case ProfileSection:{
            return 1;
        }
            break;
        case ConnectSection:{
            return 1;
        }
            break;
        case OthersSection:{
            return 3;
        }
            break;
        case SignOutSection:{
            return 1;
        }
            break;
            
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFAAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFAAccountTableViewCell"];
    switch (indexPath.section) {
        case ProfileSection:{
            if ([FIRAuth auth].currentUser.isAnonymous) {
                cell.cellImageView.image = [UIImage imageNamed:@"Profile Placeholder"];
                cell.cellLabel.text = @"Sign In";
            }
            else{
                for (id<FIRUserInfo> profile in [FIRAuth auth].currentUser.providerData) {
                    NSString *name = profile.displayName;
                    NSURL *photoURL = profile.photoURL;
                    [cell.cellImageView sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"Profile Placeholder"]];
                    cell.cellLabel.text = name;
                }
                
                
            }
            cell.cellLabel.font = [UIFont fontWithName:@".SFUIDisplay-Light" size:20];
            return cell;
        }
            break;
        case ConnectSection:{
            cell.cellImageView.image = [UIImage imageNamed:@"FriendsList"];
            cell.cellLabel.text = @"Find people on The Fuud Application";
            return cell;
        }
            break;
        case OthersSection:{
            if (indexPath.row == AppstoreRow) {
                cell.cellImageView.image = [UIImage imageNamed:@"Appstore"];
                cell.cellLabel.text = @"Rate us on the AppStore";
                return cell;
            }
            else if (indexPath.row == FeedbackRow){
                cell.cellImageView.image = [UIImage imageNamed:@"FeedBack"];
                cell.cellLabel.text = @"Send us a feedback";
                return cell;
            }
            else{
                cell.cellImageView.image = [UIImage imageNamed:@"About"];
                cell.cellLabel.text = @"About us";
                return cell;
            }
        }
            break;
        case SignOutSection:{
            cell.cellImageView.image = [UIImage imageNamed:@"Sign out"];
            cell.cellLabel.text = @"Sign out";
            return cell;
        }
            break;
            
        default:
            return cell;
            break;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case ProfileSection:{
            if ([FIRAuth auth].currentUser.isAnonymous) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Initial" bundle:nil];
                TFASignInViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TFASignInViewController"];
                [self presentViewController:vc animated:YES completion:nil];
            }
            else{
                
            }
        }
            break;
        case ConnectSection:{
            
        }
            break;
        case OthersSection:{
            switch (indexPath.row) {
                case AppstoreRow:{
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:iOS7AppStoreURLFormat, YOUR_APP_STORE_ID]];
                    [[UIApplication sharedApplication] openURL:url];
                }
                    break;
                case FeedbackRow:{
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UINavigationController *vc = [storyboard instantiateViewControllerWithIdentifier:@"TFAFeedbackViewController"];
                    [self presentViewController:vc animated:YES completion:nil];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case SignOutSection:{
            [self signOut];
        }
            break;
            
        default:
            break;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case ProfileSection:{
            return @"Profile";
        }
            break;
        case ConnectSection:{
            return @"Connections";
        }
            break;
        case OthersSection:{
            return @"Others";
        }
            break;
        case SignOutSection:{
            return @"Sign out";
        }
            break;
            
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case ProfileSection:{
            return 88;
        }
            break;
        case ConnectSection:
        case OthersSection:
        case SignOutSection:{
            return 44;
        }
            break;
        default:
            return 0;
            break;
    }
}

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
