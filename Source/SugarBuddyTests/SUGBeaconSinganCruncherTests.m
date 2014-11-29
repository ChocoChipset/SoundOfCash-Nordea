//
//  SUGBeaconSinganCruncherTests.m
//  SugarBuddy
//
//  Created by Daniele Sluijters on 29/11/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SUGBeaconSignalCruncher.h"

@interface SUGBeaconSinganCruncherTests : XCTestCase

@end

@implementation SUGBeaconSinganCruncherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddValueForNewChannel {
    SUGBeaconSignalCruncher *signalCruncher = [[SUGBeaconSignalCruncher alloc] init];
    [signalCruncher addValue:0.02 channel:@"id_0"];
    XCTAssertEqual([signalCruncher averageForChannel:@"id_0"], 0.02);
}

- (void)testAddValueToExistingChannel {
    SUGBeaconSignalCruncher *signalCruncher = [[SUGBeaconSignalCruncher alloc] init];
    [signalCruncher addValue:0.02 channel:@"id_0"];
    [signalCruncher addValue:2.02 channel:@"id_0"];
    XCTAssertEqual([signalCruncher averageForChannel:@"id_0"], 1.02);
}

- (void)testGetAverageForNonexistantChannel {
    SUGBeaconSignalCruncher *signalCruncher = [[SUGBeaconSignalCruncher alloc] init];
    XCTAssertEqual([signalCruncher averageForChannel:@"id_0"], -INFINITY);
}

@end
