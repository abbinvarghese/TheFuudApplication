//
//  TFARestaurentDetailsTableViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 23/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFARestaurentDetailsTableViewController.h"
#import "TFADetailsNameTableViewCell.h"
#import "NSMutableDictionary+TFALocation.h"
#import "TFATagTableViewCell.h"
#import "TFAWorkingHoursTableViewCell.h"
#import "TLTagsControl.h"
#import "FLocationPickerViewController.h"
#import "TFARestaurentLocationTableViewCell.h"
#import "TFAManager.h"

@interface TFARestaurentDetailsTableViewController ()<TFADetailsNameTableViewCellDelegate,TLTagsControlDelegate,FLocationPickerDelegate,TFAWorkingHoursTableViewCellDelegate>

@property (strong, nonatomic) NSString *restaurantName;
@property (strong, nonatomic) NSMutableDictionary *restaurantLocation;
@property (strong, nonatomic) NSMutableArray * restaurantPhoneNumber;
@property (strong, nonatomic) NSString * restaurantWoringFrom;
@property (strong, nonatomic) NSString * restaurantWoringTill;

@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation TFARestaurentDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TFADetailsNameTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TFADetailsNameTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TFARestaurentLocationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TFARestaurentLocationTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TFATagTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TFATagTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TFAWorkingHoursTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TFAWorkingHoursTableViewCell"];
    
    self.title = @"Restaurant details";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                                    style:UIBarButtonItemStylePlain target:self action:@selector(next:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UITableView DataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3) {
        return 2;
    }
    else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TFADetailsNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFADetailsNameTableViewCell" forIndexPath:indexPath];
        cell.cellImageView.image = [UIImage imageNamed:@"Restaurent Name"];
        cell.cellTextField.placeholder = @"Restaurant name";
        cell.cellTextField.inputAccessoryView = _toolBar;
        cell.delegate = self;
        cell.bottomBorder.hidden = YES;
        return cell;
    }
    else if (indexPath.section == 1){
        TFARestaurentLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFARestaurentLocationTableViewCell" forIndexPath:indexPath];
        return cell;
    }
    else if (indexPath.section == 2){
        TFATagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFATagTableViewCell" forIndexPath:indexPath];
        cell.tagView.tapDelegate = self;
        return cell;
    }
    else{
        TFAWorkingHoursTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFAWorkingHoursTableViewCell" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        cell.cellTextField.inputAccessoryView = _toolBar;
        if (indexPath.row == 0) {
            cell.cellTextField.placeholder = @"From";
        }
        else{
            cell.cellTextField.placeholder = @"Till";
        }
        [cell setPicker];
        return cell;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UITableView Delegate -

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Restaurant name";
    }
    else if (section == 1){
        return @"Location";
    }
    else if (section == 2){
        return @"Phone Number(optional)";
    }
    else{
        return @"Working hours(optional)";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        FLocationPickerViewController *picker = [[FLocationPickerViewController alloc]initWithNibName:@"FLocationPickerViewController" bundle:[NSBundle mainBundle]];
        picker.delegate = self;
        picker.providesPresentationContextTransitionStyle = YES;
        picker.definesPresentationContext = YES;
        picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:picker
                          animated:YES
                        completion:NULL];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 3){
        return 55;
    }
    else{
        return 55;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Custom Delegates -

-(void)workingHours:(NSString *)Hours indexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        _restaurantWoringFrom = Hours;
    }
    else{
        _restaurantWoringTill = Hours;
    }
}

-(void)tagsControl:(TLTagsControl *)tagsControl didRemoveTag:(NSString *)string{
    [_restaurantPhoneNumber removeObject:string];
}

-(void)tagsControl:(TLTagsControl *)tagsControl didAddTag:(NSString *)string{
    if (_restaurantPhoneNumber == nil) {
        _restaurantPhoneNumber = [NSMutableArray new];
    }
    [_restaurantPhoneNumber addObject:string];
}

-(void)FLocationPicker:(FLocationPickerViewController *)picker didFinishPickingPlace:(NSMutableDictionary *)location{
    TFARestaurentLocationTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.cellLabel.text =location.name;
    _restaurantLocation = location;
}

-(void)nameFieldEditingChangedWithText:(NSString *)text{
    _restaurantName = text;
}


- (IBAction)done:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
}

- (void)next:(id)sender {
    if (_restaurantName.length==0) {
        TFADetailsNameTableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
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
    if (_restaurantLocation == nil) {
        TFARestaurentLocationTableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
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
    if (_restaurantName.length>0 && _restaurantLocation) {
        [self dismissViewControllerAnimated:YES completion:^{
            [TFAManager saveItemName:_dishName price:_dishPrice description:_dishDescription images:_selectedImage restaurantName:_restaurantName location:_restaurantLocation phoneNumbers:_restaurantPhoneNumber woringFrom:_restaurantWoringFrom workingTill:_restaurantWoringTill];
        }];
    }
}
@end
