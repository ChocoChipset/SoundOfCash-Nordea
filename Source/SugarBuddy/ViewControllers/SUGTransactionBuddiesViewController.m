//
//  SUGTransactionBuddiesViewController.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGTransactionBuddiesViewController.h"
#import "SUGTransactionBuddiesViewModel.h"
#import "SUGBuddyViewCell.h"


static NSString * const SUGTransactionBuddiesCellID = @"cell-id";


@interface SUGTransactionBuddiesViewController () <UICollectionViewDataSource, SUGBeaconReceiverDelegate, SUGBackendManagerDelegate>


@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) IBOutlet UILabel *transactionTotal;
@property (nonatomic) IBOutlet UILabel *totalPerPerson;

@end


@implementation SUGTransactionBuddiesViewController


#pragma mark - View Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadUIData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isSugarDaddy) {
        [[SUGBackendManager sharedManager] createSplitBillWithTransactionID:self.transactionID];
        [SUGBackendManager sharedManager].delegate = self;
        
        [[SUGBeaconManager sharedManager].broadcaster startBroadCasting];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[SUGBeaconManager sharedManager].receiver stopReadingRSSI];
    [[SUGBeaconManager sharedManager].broadcaster stopBroadCasting];
}

#pragma mark -

- (void)reloadUIData
{
    self.title = self.viewModel.transactionTitle;
    self.transactionTotal.text = [self.viewModel transactionTitle];
    self.totalPerPerson.text = [self.viewModel transactionSubtitle];

    [[self collectionView] reloadData];
}

#pragma mark - UICollectionViewDelegate


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
    SUGBuddyViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SUGTransactionBuddiesCellID
                                                                           forIndexPath:indexPath];
    cell.textLabel.text = [self.viewModel titleForIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"icon_person.png"];
    
    return cell;
}

#pragma mark - SUGBackendManagerDelegate

- (void)backendManager:(SUGBackendManager *)backendManager responseObject:(id)response
{
    if (!response)  {
        NSLog(@"ERROR");
        return;
    }
    
    self.viewModel = [[SUGTransactionBuddiesViewModel alloc] initWithTransaction:response];
    [self reloadUIData];
}


@end
