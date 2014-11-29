//
//  SUGTransactionBuddiesViewModel.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGTransactionBuddiesViewModel.h"

@implementation SUGTransactionBuddiesViewModel

- (instancetype)initWithTransaction:(NSDictionary *)transaction
{
    if (!(self = [super init])) {
        return nil;
    }
        
    return self;
}

#pragma mark -

- (BOOL)isSugarDaddy
{
    return YES;
}

- (NSString *)transactionTitle
{
    return @"Dinner";
}

- (NSString *)transactionSubtitle
{
    return @"140 SEK";
}

- (NSString *)transactionMetadataTitle
{
    return @"20 SEK per person";
}

- (NSInteger)numberOfSections
{
    return 1;
}

- (NSInteger)numberOfItemsForSection:(NSInteger)section
{
    return 2;
}

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath
{
    return @"Jimmy Neutron";
}


@end
