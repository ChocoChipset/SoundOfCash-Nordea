//
//  SUGBackendManager.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGBackendManager.h"

static SUGBackendManager *static_backendManager = nil;

@implementation SUGBackendManager

+ (instancetype)sharedManager
{
    if (!static_backendManager) {
        static_backendManager = [[self alloc] init];
    }
    
    return static_backendManager;
}

- (void)getTransactions
{
    NSLog(@"GET Transactions");
}

@end
