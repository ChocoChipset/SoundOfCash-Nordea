//
//  SUGBackendManager.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGBackendManager.h"
#import <UNIRest.h>

static SUGBackendManager *static_backendManager = nil;

@implementation SUGBackendManager

+ (instancetype)sharedManager
{
    if (!static_backendManager) {
        static_backendManager = [[self alloc] init];
    }
    
    return static_backendManager;
}

- (NSString *)deviceID
{
    return [[UIDevice currentDevice] name];
}

- (NSArray*)getTransactions:(NSString*)accountID
{
    accountID = self.deviceID;
    
    NSString* url = [NSString stringWithFormat:@"https://soundofcash.mybluemix.net/api/transactions?account=%@", accountID];
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:url];
    }] asJson];
    NSDictionary *responseBody = [[response body] object];
    return (NSArray*) [responseBody objectForKey:@"transactions"];
}

- (NSDictionary*)createSplitBill:(NSString*)transactionID
{
    NSLog(@"create split bill for transaction %@", transactionID);
    
    NSDictionary* parameters = @{@"transaction": transactionID};
    
    UNIHTTPJsonResponse *response = [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://soundofcash.mybluemix.net/api/bills"];
        [request setParameters:parameters];
    }] asJson];
    return [[response body] object];
}

- (NSDictionary*)commitSplitBill:(NSString*)billID
{
    NSLog(@"commit split bill %@", billID);
    
    NSDictionary* parameters = @{@"action": @"commit"};
    NSString* url = [NSString stringWithFormat:@"https://soundofcash.mybluemix.net/api/bills/%@", billID];
    
    UNIHTTPJsonResponse *response = [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:url];
        [request setParameters:parameters];
    }] asJson];
    return [[response body] object];
}

- (NSDictionary*)discoverSplitBill:(NSArray*)beaconsIDs
{
    NSLog(@"discover split bills");
    
    NSString* beacons = [beaconsIDs componentsJoinedByString:@"&beacon="];
    NSString* url = [NSString stringWithFormat:@"https://soundofcash.mybluemix.net/api/bills?beacon=%@", beacons];
    
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:url];
    }] asJson];
    return [[response body] object];
}

- (NSDictionary*)joinSplitBill:(NSString*)billID withAccount:(NSString*)accountID
{
    NSLog(@"join split bill %@ for account %@", billID, accountID);
    
    NSDictionary* parameters = @{@"action": @"join", @"account": accountID};
    NSString* url = [NSString stringWithFormat:@"https://soundofcash.mybluemix.net/api/bills/%@", billID];
    UNIHTTPJsonResponse *response = [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:url];
        [request setParameters:parameters];
    }] asJson];
    return [[response body] object];
}

- (NSDictionary*)pollSplitBill:(NSString*)billID
{
    NSLog(@"poll split bill %@", billID);
    
    NSString* url = [NSString stringWithFormat:@"https://soundofcash.mybluemix.net/api/bills/%@", billID];
    UNIHTTPJsonResponse *response = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:url];
    }] asJson];
    return [[response body] object];
}

@end
