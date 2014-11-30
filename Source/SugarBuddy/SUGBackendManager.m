//
//  SUGBackendManager.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGBackendManager.h"
#import <UNIRest.h>
#import "NSString+Hashing.h"


static SUGBackendManager *static_backendManager = nil;

@implementation SUGBackendManager

+ (instancetype)sharedManager
{
    if (!static_backendManager) {
        static_backendManager = [[self alloc] init];
    }
    
    return static_backendManager;
}

#pragma mark - User ID


- (NSString *)deviceID
{
    return [[[UIDevice currentDevice] name] SHA1];
}

#pragma mark - Delegate Stuff

- (void)notifyDelegateWithResponseObject:(id)responseObject
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate backendManager:self responseObject:responseObject];
    });
}



#pragma mark - Calls

- (void)getTransactions
{
    NSString* url = [NSString stringWithFormat:@"https://soundofcash.mybluemix.net/api/transactions?account=%@", self.deviceID];
    
    [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:url];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        NSDictionary *responseBody = [[jsonResponse body] object];
        NSArray *responseObject = (NSArray*) [responseBody objectForKey:@"transactions"];
        
        [self notifyDelegateWithResponseObject:responseObject];

    }];
}

- (void)createSplitBillWithTransactionID:(NSString*)transactionID
{
    NSLog(@"create split bill for transaction %@", transactionID);
    
    NSDictionary* parameters = @{@"transaction": transactionID};
    
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://soundofcash.mybluemix.net/api/bills"];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        NSDictionary *responseBody = [[jsonResponse body] object];
        [self notifyDelegateWithResponseObject:responseBody];
    }];
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

- (void)joinOpenBillForBeaconWithID:(NSString*)beaconID
{
    NSLog(@"join open bill for beacon with ID %@", beaconID);
    
    NSDictionary* parameters = @{@"account": self.deviceID,
                                 @"beacon": beaconID};
    NSString* url = [NSString stringWithFormat:@"https://soundofcash.mybluemix.net/api/join"];
    [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:url];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        NSDictionary *responseBody = [[jsonResponse body] object];
        [self notifyDelegateWithResponseObject:responseBody];
    }];
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
