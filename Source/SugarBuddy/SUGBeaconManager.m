#import "SUGBeaconManager.h"
#import "SUGBeaconBroadcaster.h"
#import "SUGBeaconReceiver.h"

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
    
    _broadcaster = [[SUGBeaconBroadcaster alloc] init];
    _receiver = [[SUGBeaconReceiver alloc] init];
    
    return self;
}

- (void)initialize
{
    /**
     *  Any setup required at the beginning of the singleton.
     */
}


@end
