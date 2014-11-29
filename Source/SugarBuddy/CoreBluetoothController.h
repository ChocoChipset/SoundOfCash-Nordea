//
//  CoreBluetoothController.h
//  Estimote Simulator
//
//  Created by Grzegorz Krukiewicz-Gacek on 24.07.2013.
//  Copyright (c) 2013 Estimote, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol CoreBluetoothDelegate
@optional
- (void)didFindBeacon;
- (void)didConnectToBeacon;
- (void)didDetectInteraction;
- (void)didUpdateRSSI:(int)RSSI;

- (void)didConnectToListener;
@end

@interface CoreBluetoothController : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong) CBPeripheral *pairedPeripheral;
@property (nonatomic, weak) id <CoreBluetoothDelegate> delegate;
@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, getter=isConnected) BOOL connected;


- (void)findPeripherals;

- (void)startReadingRSSI;
- (void)stopReadingRSSI;

- (int)averageFromLastRSSI;

@end
