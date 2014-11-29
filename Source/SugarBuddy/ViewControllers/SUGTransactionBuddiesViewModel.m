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

@end



@implementation SUGTransactionBuddiesViewModel

- (instancetype)initWithTransaction:(NSDictionary *)transaction
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _transaction = transaction;
        
    return self;
}

#pragma mark -


- (NSString *)transactionTitle
{
    return self.transaction[@"transaction"][@"title"];
}

- (NSString *)transactionSubtitle
{
    NSString *title = [NSString stringWithFormat:@"%@ %@ each", self.transaction[@"splitamount"], self.transaction[@"currency"]];
    
    return title;
}

- (NSString *)transactionMetadataTitle
{
    return [NSString stringWithFormat:@"%@ %@", self.transaction[@"transaction"][@"amount"], self.transaction[@"transaction"][@"currency"]];

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



@end
