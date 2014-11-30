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
@property (nonatomic) NSNumberFormatter *formatter;
@end


@implementation SUGLatestTransactionsViewModel

- (instancetype)initWithTransactions:(NSArray *)transactions
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _formatter = [[NSNumberFormatter alloc] init];
    [_formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [_formatter setCurrencyDecimalSeparator:@"."];

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
    return self.transactions.count;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *transaction = [self transactionForIndexPath:indexPath];
    
    return transaction[@"title"];
}

- (NSString *)subtitleForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *transaction = [self transactionForIndexPath:indexPath];

    return [NSString stringWithFormat:@"%@", [self.formatter stringFromNumber:@([transaction[@"amount"] doubleValue])]];
}

- (double)latitudeForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *transaction = [self transactionForIndexPath:indexPath];
    return [transaction[@"latitude"] doubleValue];
}

- (double)longitudeForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *transaction = [self transactionForIndexPath:indexPath];
    return [transaction[@"longitude"] doubleValue];
}

- (NSDictionary *)transactionForIndexPath:(NSIndexPath *)indexPath
{
    return self.transactions[indexPath.row];
}

@end
