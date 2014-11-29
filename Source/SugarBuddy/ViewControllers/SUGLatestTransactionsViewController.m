
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


static NSString * const SUGTransactionBuddiesCellID = @"transactions-cell-id";


@interface SUGLatestTransactionsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SUGLatestTransactionsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) {
        return nil;
    }
    
    _viewModel = [[SUGLatestTransactionsViewModel alloc] initWithTransactions:nil];
    
    return self;
}


#pragma mark - View Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadUIData];
    
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
    NSDictionary *commitedBill = [backend commitSplitBill:billID];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)sender
{
    if ([segue.identifier isEqualToString:SUGTransitionIDForBuddiesTransition]) {
        SUGTransactionBuddiesViewController *nextVC = segue.destinationViewController;
        
        id transaction = [self.viewModel transactionForIndexPath:sender];
        
        nextVC.viewModel = [[SUGTransactionBuddiesViewModel alloc] initWithTransaction:transaction];
        nextVC.viewModel.sugarDaddy = YES;
    }
}


#pragma mark -

- (void)reloadUIData
{
    self.title = @"Recent Transactions";
    
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

@end
