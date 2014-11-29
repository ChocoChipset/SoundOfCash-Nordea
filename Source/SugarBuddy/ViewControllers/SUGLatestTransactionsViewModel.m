//
//  SUGLatestTransactionsViewModel.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGLatestTransactionsViewModel.h"

@interface SUGLatestTransactionsViewModel ()

@property (nonatomic) NSArray *transactions;

@end


@implementation SUGLatestTransactionsViewModel

- (instancetype)initWithTransactions:(NSArray *)transactions
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _transactions = transactions;
    
    return self;
}


#pragma mark -


- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)numberOfItemsForSection:(NSInteger)section
{
    return 9;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    return @"Transaction";
}

- (NSString *)subtitleForIndexPath:(NSIndexPath *)indexPath
{
    return @"Subtitle for Transaction";
}

- (id)transactionForIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
