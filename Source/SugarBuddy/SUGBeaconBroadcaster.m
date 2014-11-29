//
//  SUGBeaconBroadcaster.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGBeaconBroadcaster.h"

@interface SUGBeaconBroadcaster () <CBPeripheralManagerDelegate>

@property (nonatomic) NSMutableArray *centrals;

@end

@implementation SUGBeaconBroadcaster

- (instancetype)init
{
    if (!(self = [super init])) {
        return nil;
    }
    
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    
    _centrals = [NSMutableArray array];
    
    return self;
    
}


- (void)dealloc
{
    [self.peripheralManager stopAdvertising];
}

#pragma mark - CBPeripheral delegate methods

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    NSLog(@"PeripheralManager powered on.");
    
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString: SUGBTCharacteristicUUID]
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];
    
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:SUGBTServiceUUID]
                                                                       primary:YES];
    
    transferService.characteristics = @[self.transferCharacteristic];
    
    [self.peripheralManager addService:transferService];
    
    [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:SUGBTServiceUUID]],
                                                CBAdvertisementDataLocalNameKey : SUGBTServiceLocalNameKey }];
    
    NSLog(@"PeripheralManager is broadcasting (%@).", SUGBTCharacteristicUUID);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    [self.centrals addObject:central];
}


@end