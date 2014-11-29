//
//  SUGBackendManager.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGBackendManager.h"
#import <CommonCrypto/CommonDigest.h>
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

#pragma mark - User ID


- (NSString *)deviceID
{
    return [self sha1: [[UIDevice currentDevice] name]];
}

-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;

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
    
    UNIHTTPJsonResponse *response = [[UNIRest post:^(UNISimpleRequest *request) {
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
