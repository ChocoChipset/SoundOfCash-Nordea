//
//  SUGLatestTransactionsViewController.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGLatestTransactionsViewController.h"
#import "SUGLatestTransactionsViewModel.h"


static NSString * const SUGTransactionBuddiesCellID = @"transactions-cell-id";


@interface SUGLatestTransactionsViewController () <UICollectionViewDataSource>


@property (nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SUGLatestTransactionsViewController




#pragma mark - View Lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reloadUIData];
}

#pragma mark -

- (void)reloadUIData
{

    [self.collectionView reloadData];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SUGTransactionBuddiesCellID
                                                                       forIndexPath:indexPath];
//    cell.textLabel.text = [self.viewModel titleForIndexPath:indexPath];
//    cell.imageView.image = [UIImage imageNamed:@"icon_person.png"];
    
    return cell;
}

@end