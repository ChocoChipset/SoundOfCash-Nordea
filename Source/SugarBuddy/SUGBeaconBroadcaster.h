//
//  SUGBeaconBroadcaster.h
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>


@interface SUGBeaconBroadcaster : NSObject

- (void)startBroadCasting;
- (void)stopBroadCasting;

@end
