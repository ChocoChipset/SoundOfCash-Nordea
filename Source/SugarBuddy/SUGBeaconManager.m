#import "SUGBeaconManager.h"


static SUGBeaconManager *static_beaconManager = nil;

@interface SUGBeaconManager ()


@end



@implementation SUGBeaconManager


+ (instancetype)sharedManager
{
    if (!static_beaconManager) {
        static_beaconManager = [[self alloc] init];
    }
    
    return static_beaconManager;
}



- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    
    return self;
}


@end
