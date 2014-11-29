//
//  SUGBeaconSignalCruncher.m
//  SugarBuddy
//
//  Created by Daniele Sluijters on 29/11/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGBeaconSignalCruncher.h"

@interface SUGBeaconSignalCruncher ()
@property (nonatomic, strong) NSMutableDictionary * channels;
@end

@implementation SUGBeaconSignalCruncher


- (id)init {
    self = [super init];
    
    if(self) {
        self.channels = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (double)averageForChannel: (NSString *)channel {
    if ([self.channels objectForKey:channel]) {
        NSInteger sz = [[self.channels objectForKey:channel] count];
        NSNumber * total = [[self.channels objectForKey:channel] valueForKeyPath:@"@sum.self"];
        return ([total doubleValue] / sz);
    } else {
        return -INFINITY;
    }
}

- (void)addValue: (double)measurement channel:(NSString *)channel {
    NSNumber *t_measurement = [[NSNumber alloc] initWithDouble:(measurement)];
    if ([self.channels objectForKey:channel]) {
        [[self.channels objectForKey:channel] addObject:t_measurement];
    } else {
        [self.channels setObject:[NSMutableArray arrayWithObject:t_measurement] forKey:channel];
    }
    
    if ([[self.channels objectForKey:channel] count] > 9) {
        [[self.channels objectForKey:channel] removeObjectAtIndex:0];
    }
    
}

@end
