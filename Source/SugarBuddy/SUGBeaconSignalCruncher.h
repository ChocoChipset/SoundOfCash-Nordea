//
//  SUGBeaconSignalCruncher.h
//  SugarBuddy
//
//  Created by Daniele Sluijters on 29/11/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUGBeaconSignalCruncher : NSObject
- (double)averageForChannel: (NSString *)channel;
- (void)addValue: (double)measurement channel:(NSString *)channel;
@end
