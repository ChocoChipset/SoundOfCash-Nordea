//
//  SUGTransactionBuddiesViewModel.h
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface SUGTransactionBuddiesViewModel : NSObject

@property (nonatomic) NSString *transactionID;

@property (nonatomic) NSInteger numberOfSections;

@property (nonatomic) NSString *transactionTitle;
@property (nonatomic) NSString *transactionSubtitle;
@property (nonatomic) NSString *transactionMetadataTitle;

- (NSInteger)numberOfItemsForSection:(NSInteger)section;

- (NSString *)titleForIndexPath:(NSIndexPath *)indexPath;

- (NSURL *)imageURLForIndexPath:(NSIndexPath *)indexPath;

- (instancetype)initWithTransaction:(NSDictionary *)transaction;

@end
