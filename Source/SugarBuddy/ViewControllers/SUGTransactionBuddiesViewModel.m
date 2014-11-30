//
//  SUGTransactionBuddiesViewModel.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGTransactionBuddiesViewModel.h"


@interface SUGTransactionBuddiesViewModel ()

@property (nonatomic, strong) NSDictionary *transaction;
@property (nonatomic) NSNumberFormatter *formatter;
@end



@implementation SUGTransactionBuddiesViewModel

- (instancetype)initWithTransaction:(NSDictionary *)transaction
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _formatter = [[NSNumberFormatter alloc] init];
    [_formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    [_formatter setCurrencyDecimalSeparator:@"."];
    _transaction = transaction;
        
    return self;
}

#pragma mark -


- (NSString *)transactionID
{
    return self.transaction[@"transaction"][@"id"];
}

- (NSString *)transactionTitle
{
    return self.transaction[@"transaction"][@"title"];
}

- (NSString *)transactionSubtitle
{
    double splitAmount = [self.transaction[@"splitamount"] doubleValue];
    NSString *title = [NSString stringWithFormat:@"%@", [self.formatter stringFromNumber:@(splitAmount)]];
    
    return title;
}

- (NSString *)transactionMetadataTitle
{
    NSString *totalAmountString = [NSString stringWithFormat:@"Total: %@ %@", self.transaction[@"transaction"][@"amount"], self.transaction[@"transaction"][@"currency"]];
    
    return totalAmountString;

}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)numberOfItemsForSection:(NSInteger)section
{
    return ((NSArray *)self.transaction[@"participants"]).count;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *participantAtIndex = ((NSArray *)self.transaction[@"participants"])[indexPath.row];
    
    return participantAtIndex[@"name"];
}

- (NSURL *)imageURLForIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *participantAtIndex = ((NSArray *)self.transaction[@"participants"])[indexPath.row];
    
    NSString *imageURLString = participantAtIndex[@"image"];
    
    return [NSURL URLWithString:imageURLString];
    
}


@end
