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
    
    [[SUGBackendManager sharedManager] getTransactions];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)sender
{
    if ([segue.identifier isEqualToString:SUGTransitionIDForBuddiesTransition]) {
        SUGTransactionBuddiesViewController *nextVC = segue.destinationViewController;
        
        id transaction = [self.viewModel transactionForIndexPath:sender];
        
        nextVC.viewModel = [[SUGTransactionBuddiesViewModel alloc] initWithTransaction:transaction];
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
