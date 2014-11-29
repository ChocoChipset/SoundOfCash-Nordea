//
//  SUGBeaconManager.h
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SUGBeaconBroadcaster;

@interface SUGBeaconManager : NSObject

@property (nonatomic) SUGBeaconBroadcaster *broadcaster;
@property (nonatomic) id receiver;

+ (instancetype)sharedManager;

@end
