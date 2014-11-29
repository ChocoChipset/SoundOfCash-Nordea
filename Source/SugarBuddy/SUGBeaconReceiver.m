//
//  CoreBluetoothController.m
//  Estimote Simulator
//
//  Created by Grzegorz Krukiewicz-Gacek on 24.07.2013.
//  Copyright (c) 2013 Estimote, Inc. All rights reserved.
//

#import "SUGBeaconReceiver.h"

@interface SUGBeaconReceiver ()

@property (nonatomic, strong) NSTimer *readRSSITimer;
@property (nonatomic, strong) NSMutableArray *rssiArray;
@property (nonatomic, assign) int rssiArrayIndex;

@end

@implementation SUGBeaconReceiver

- (id)init {
	self = [super init];
    
	if(self) {
        
		self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _rssiArrayIndex = 0;
	}
    
    return self;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{    
    if (central.state == CBCentralManagerStatePoweredOn) 
        [self findPeripherals];
    
    else {
        
        //should invoke a delegate method
    }
}

- (void)findPeripherals;
{    
    if (self.manager.state != CBCentralManagerStatePoweredOn)
        NSLog (@"CoreBluetooth not initialized correctly!");
    
    else {
        
        NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:SUGBTServiceUUID], nil];
        NSDictionary *options = [NSDictionary dictionaryWithObject: [NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
        
        [self.manager scanForPeripheralsWithServices:uuidArray options:options];
    }
}

#pragma mark - CBCentralManager delegate methods

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%@", peripheral);
        
    self.pairedPeripheral = peripheral;
    [self.manager connectPeripheral:self.pairedPeripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    self.connected = YES;
    
    [self.manager stopScan];
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:SUGBTServiceUUID]]];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    id tempDelegate = self.delegate;
    if ([tempDelegate respondsToSelector:@selector(beaconPeripheral:didUpdateRSSI:)]) {
        [self.delegate beaconPeripheral:peripheral didUpdateRSSI:-100];
    }
    self.connected = NO;
}

#pragma mark - CBPeripheral delegate methods

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        return;
    }
        
    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:SUGBTCharacteristicUUID]] forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SUGBTCharacteristicUUID]]) {
            
            id tempDelegate = self.delegate;
            if ([tempDelegate respondsToSelector:@selector(didConnectToBeacon)])    
                [self.delegate didConnectToBeacon];
            
            [self.pairedPeripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    // int RSSIvalue = [peripheral.RSSI intValue];
    
    if (!_rssiArray.count)
        _rssiArray = [[NSMutableArray alloc] initWithArray: @[peripheral.RSSI, peripheral.RSSI, peripheral.RSSI, peripheral.RSSI, peripheral.RSSI]];

    [_rssiArray replaceObjectAtIndex:_rssiArrayIndex withObject:peripheral.RSSI];
    _rssiArrayIndex ++;
    
    if (_rssiArrayIndex > 4)
        _rssiArrayIndex = 0;
    
    if (self.delegate) {
       
        id tempDelegate = self.delegate;
        if ([tempDelegate respondsToSelector:@selector(beaconPeripheral:didUpdateRSSI:)])
            [self.delegate beaconPeripheral:peripheral
                              didUpdateRSSI:[self averageFromLastRSSI]];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    id tempDelegate = self.delegate;
    if ([tempDelegate respondsToSelector:@selector(didDetectInteraction)])
        [self.delegate didDetectInteraction];
}

- (void)startReadingRSSI
{
    _readRSSITimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(readPeripheralRSSI) userInfo:nil repeats:YES];
    [_readRSSITimer fire];
}

- (void)stopReadingRSSI
{
    [_readRSSITimer invalidate];
    _readRSSITimer = nil;
}

- (void)readPeripheralRSSI
{
    [self.pairedPeripheral readRSSI];
}

- (int)averageFromLastRSSI
{
    int sum = 0;
    
    for (NSNumber *rssi in _rssiArray)
        sum = sum + [rssi intValue];
    
    return (int)sum/5;
}

@end
