//
//  FLocationPickerViewController.m
//  Foodu
//
//  Created by Abbin on 18/03/16.
//  Copyright © 2016 Paadam. All rights reserved.
//

#import "FLocationPickerViewController.h"
#import "NSMutableDictionary+TFALocation.h"

@interface FLocationPickerViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) GMSAutocompleteFetcher *fetcher;
@property (strong, nonatomic) NSArray *listArray;

@end

@implementation FLocationPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    filter.country = countryCode;
    filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
    self.fetcher = [[GMSAutocompleteFetcher alloc] initWithBounds:nil filter:filter];
    self.fetcher.delegate = self;
    
    [_listTableView registerNib:[UINib nibWithNibName:@"TFACurrentLocationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TFACurrentLocationTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UISearchBar Delegate -

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.label.text = @"";
    [self.activityIndicator startAnimating];
    [self.fetcher sourceTextHasChanged:searchText];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UITableView DataSource -


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TFACurrentLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TFACurrentLocationTableViewCell"];
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCellID"];
        }
        GMSAutocompletePrediction *prediction = [self.listArray objectAtIndex:indexPath.row-1];
        cell.textLabel.attributedText = prediction.attributedPrimaryText;
        cell.detailTextLabel.attributedText = prediction.attributedSecondaryText;
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.detailTextLabel.textColor = [UIColor darkTextColor];
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - UITableView Delegate -


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.height/10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [_activityIndicator startAnimating];
        [[GMSPlacesClient sharedClient] currentPlaceWithCallback:^(GMSPlaceLikelihoodList * _Nullable likelihoodList, NSError * _Nullable error) {
            if (error == nil) {
                GMSPlaceLikelihood *likelihood = [likelihoodList.likelihoods objectAtIndex:0];
                GMSPlace* place = likelihood.place;
                NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:place];
                [_activityIndicator stopAnimating];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self.delegate respondsToSelector:@selector(FLocationPicker:didFinishPickingPlace:)]) {
                        [self.delegate FLocationPicker:self didFinishPickingPlace:obj];
                    }
                }];
            }
            else{
                [_activityIndicator stopAnimating];
                UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to get your current location" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }];
    }
    else{
        [_activityIndicator startAnimating];
        GMSAutocompletePrediction *prediction = [self.listArray objectAtIndex:indexPath.row-1];
        
        [[GMSPlacesClient sharedClient] lookUpPlaceID:prediction.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
            if (error == nil) {
                [_activityIndicator stopAnimating];
                NSMutableDictionary *obj = [[NSMutableDictionary alloc]initWithGMSPlace:result];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self.delegate respondsToSelector:@selector(FLocationPicker:didFinishPickingPlace:)]) {
                        [self.delegate  FLocationPicker:self didFinishPickingPlace:obj];
                    }
                }];
            }
            else{
                [_activityIndicator stopAnimating];
                UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to get location" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - GMSAutocompleteFetcher Delegate -


- (void)didAutocompleteWithPredictions:(NSArray *)predictions {
    [self.activityIndicator stopAnimating];
    
    if (predictions.count>0) {
        self.label.text = @"";
    }
    else{
        self.label.text = @"No results found";
    }
    self.listArray = predictions;
    [self.listTableView reloadData];
}

- (void)didFailAutocompleteWithError:(NSError *)error {
    self.label.text = @"No results found";
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - Actions -


- (IBAction)dismissButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
