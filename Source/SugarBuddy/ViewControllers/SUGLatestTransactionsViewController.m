
//
//  SUGLatestTransactionsViewController.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//
#import "SUGTransactionBuddiesViewController.h"
#import "SUGLatestTransactionsViewController.h"
#import "SUGLatestTransactionsViewModel.h"
#import "SUGTransactionCollectionViewCell.h"
#import "SUGBackendManager.h"
#import "SUGTransactionBuddiesViewModel.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


static NSString * const SUGTransactionBuddiesCellID = @"transactions-cell-id";


@interface SUGLatestTransactionsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SUGBackendManagerDelegate>


@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) IBOutlet UILabel *transactionTitle;
@property (nonatomic) IBOutlet UILabel *transactionTotal;
@property (nonatomic) IBOutlet MKMapView *map;


@end

@implementation SUGLatestTransactionsViewController


#pragma mark - View Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadUIData];
    
    [SUGBackendManager sharedManager].delegate = self;
    [[SUGBackendManager sharedManager] getTransactions];
    /*
    // sugar daddy flow
    NSString *daddyAccount = @"hectorsaccount";
    SUGBackendManager *backend = [SUGBackendManager sharedManager];
    NSArray *transactions = [backend getTransactions:daddyAccount];
    NSDictionary *firstTransaction = transactions[0];
    NSString *firstTransactionID = [firstTransaction objectForKey:@"id"];
    NSDictionary *splitBill = [backend createSplitBill:firstTransactionID];
    NSString *billID = [splitBill objectForKey:@"id"];
    
    // sugar baby flow
    NSString *babyAccount = @"marcsaccount";
    NSMutableArray *visibleBeacons = [NSMutableArray arrayWithObject:@"hectorsbeacon"];
    NSDictionary *discoveredBill = [backend discoverSplitBill:visibleBeacons];
    NSString* discoveredID = [discoveredBill objectForKey:@"id"];
    discoveredBill = [backend joinSplitBill:discoveredID withAccount:babyAccount];
    
    // monitor the bill
    splitBill = [backend pollSplitBill:billID];
    
    // commit
    NSDictionary *commitedBill = [backend commitSplitBill:billID];*/
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)sender
{
    if ([segue.identifier isEqualToString:SUGTransitionIDForBuddiesTransition]) {
        SUGTransactionBuddiesViewController *nextVC = segue.destinationViewController;
        
        id transaction = [self.viewModel transactionForIndexPath:sender];
        
        nextVC.transactionID = transaction[@"id"];
        nextVC.sugarDaddy = YES;
    }
}


#pragma mark -

- (void)reloadUIData
{
    self.transactionTitle.text = [self.viewModel titleForIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    self.transactionTotal.text = [self.viewModel subtitleForIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    CLLocationCoordinate2D location;
    location.latitude = [self.viewModel latitudeForIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    location.longitude = [self.viewModel longitudeForIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (location, 2000, 2000);
    MKPointAnnotation *pin = [[MKPointAnnotation alloc]init];
    pin.coordinate = location;
    pin.title = [self.viewModel titleForIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [self.map setRegion:region animated:NO];
    [self.map addAnnotation:pin];

    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:SUGTransitionIDForBuddiesTransition
                              sender:indexPath];
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.viewModel.numberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numberOfItemsForSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SUGTransactionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SUGTransactionBuddiesCellID
                                                                       forIndexPath:indexPath];
    cell.textLabel.text = [self.viewModel titleForIndexPath:indexPath];
    cell.detailLabel.text  = [self.viewModel subtitleForIndexPath:indexPath];
    
    return cell;
}

#pragma mark - 

- (void)backendManager:(SUGBackendManager *)backendManager responseObject:(NSArray *)response
{
    if (!response) {
        NSLog(@"ERROR");
        return;
    }
    
    self.viewModel = [[SUGLatestTransactionsViewModel alloc] initWithTransactions:response];
    [self reloadUIData];
}

@end
