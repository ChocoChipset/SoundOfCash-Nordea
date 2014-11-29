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


@interface SUGTransactionBuddiesViewController () <UICollectionViewDataSource>

@property (nonatomic) IBOutlet UICollectionView *collectionView;

@end


@implementation SUGTransactionBuddiesViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) {
        return nil;
    }
    
    _viewModel = [[SUGTransactionBuddiesViewModel alloc] initWithTransaction:nil];
    
    return self;
}


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
    
    return cell;
}

@end
