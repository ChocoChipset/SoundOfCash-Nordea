//
//  SUGLatestTransactionsViewModel.h
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUGLatestTransactionsViewModel : NSObject

@property (nonatomic) NSInteger numberOfSections;

- (NSInteger)numberOfItemsForSection:(NSInteger)section;

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath;

- (NSString *)subtitleForIndexPath:(NSIndexPath *)indexPath;

- (NSDictionary *)transactionForIndexPath:(NSIndexPath *)indexPath;

- (double)latitudeForIndexPath:(NSIndexPath *)indexPath;

- (double)longitudeForIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithTransactions:(NSArray *)transactions;


@end
