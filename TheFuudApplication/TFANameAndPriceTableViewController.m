//
//  TFANameAndPriceTableViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFANameAndPriceTableViewController.h"
#import "TFADetailsImagePreviewTableViewCell.h"
#import "TFADetailsNameTableViewCell.h"
#import "TFADetailsPriceTableViewCell.h"
#import "TFADetailsDescriptionTableViewCell.h"
#import "TFARestaurentDetailsTableViewController.h"

@interface TFANameAndPriceTableViewController ()<TFADetailsNameTableViewCellDelegate,TFADetailsPriceTableViewCellDelegate,TFADetailsDescriptionTableViewCellDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@property (strong, nonatomic) NSString *dishName;
@property (strong, nonatomic) NSString *dishPrice;
@property (strong, nonatomic) NSString *dishDescription;

@end

@implementation TFANameAndPriceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"Name and Price";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TFADetailsImagePreviewTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TFADetailsImagePreviewTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TFADetailsNameTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TFADetailsNameTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TFADetailsPriceTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TFADetailsPriceTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TFADetailsDescriptionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TFADetailsDescriptionTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UITableView Data Source -


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else{
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TFADetailsImagePreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFADetailsImagePreviewTableViewCell"];
        cell.selectedImage = _selectedImage;
        return cell;
    }
    else{
        if (indexPath.row == 0){
            TFADetailsNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFADetailsNameTableViewCell"];
            cell.cellTextField.inputAccessoryView = self.toolBar;
            cell.delegate = self;
            return cell;
        }
        else if (indexPath.row == 1){
            TFADetailsPriceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFADetailsPriceTableViewCell"];
            cell.cellTextField.inputAccessoryView = self.toolBar;
            cell.delegate = self;
            return cell;
        }
        else{
            TFADetailsDescriptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFADetailsDescriptionTableViewCell"];
            cell.cellTextView.inputAccessoryView = self.toolBar;
            cell.delegate = self;
            return cell;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UITableView Delegate -


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Image Preview";
    }
    else{
        return @"Details";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return tableView.frame.size.height/3;
    }
    else{
        if (indexPath.row == 2){
            return tableView.frame.size.height/5;
        }
        else{
            return 55;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Custom Delegates -


-(void)nameFieldEditingChangedWithText:(NSString *)text{
    _dishName = text;
}

-(void)priceFieldEditingChangedWithText:(NSString *)text{
    _dishPrice = text;
}

-(void)descriptionFieldEditingChangedWithText:(NSString *)text{
    _dishDescription = text;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Actions -


- (IBAction)toolBarDone:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
}

- (void)dismiss:(id)sender {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes, I'm sure" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:yes];
    [controller addAction:cancel];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)next:(id)sender {
    if (_dishName.length>0 && _dishPrice.length>0) {
        [self.view endEditing:YES];
        TFARestaurentDetailsTableViewController *vc = [[TFARestaurentDetailsTableViewController alloc]initWithNibName:@"TFARestaurentDetailsTableViewController" bundle:[NSBundle mainBundle]];
        vc.selectedImage = _selectedImage;
        vc.dishName = _dishName;
        vc.dishPrice = _dishPrice;
        vc.dishDescription = _dishDescription;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (_dishName.length==0){
        TFADetailsNameTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        CABasicAnimation *animation =
        [CABasicAnimation animationWithKeyPath:@"position"];
        [animation setDuration:0.05];
        [animation setRepeatCount:3];
        [animation setAutoreverses:YES];
        [animation setFromValue:[NSValue valueWithCGPoint:
                                 CGPointMake([cell.cellImageView center].x - 5.0f, [cell.cellImageView center].y)]];
        [animation setToValue:[NSValue valueWithCGPoint:
                               CGPointMake([cell.cellImageView center].x + 5.0f, [cell.cellImageView center].y)]];
        [[cell.cellImageView layer] addAnimation:animation forKey:@"position"];
    }
    if (_dishPrice.length == 0){
        TFADetailsNameTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        TFADetailsPriceTableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        if ([cell.cellTextField isFirstResponder]) {
            [cell2.cellTextField becomeFirstResponder];
        }
        else{
            CABasicAnimation *animation =
            [CABasicAnimation animationWithKeyPath:@"position"];
            [animation setDuration:0.05];
            [animation setRepeatCount:3];
            [animation setAutoreverses:YES];
            [animation setFromValue:[NSValue valueWithCGPoint:
                                     CGPointMake([cell.cellImageView center].x - 5.0f, [cell.cellImageView center].y)]];
            [animation setToValue:[NSValue valueWithCGPoint:
                                   CGPointMake([cell.cellImageView center].x + 5.0f, [cell.cellImageView center].y)]];
            [[cell2.cellImageView layer] addAnimation:animation forKey:@"position"];
        }
    }
}

@end
