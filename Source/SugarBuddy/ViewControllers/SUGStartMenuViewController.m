//
//  SUGStartMenuViewController.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGStartMenuViewController.h"
#import "SUGLatestTransactionsViewController.h"
#import "SUGTransactionBuddiesViewController.h"
#import "SUGTransactionBuddiesViewModel.h"

const NSInteger SUGStartMenuBeaconThreshold = -30;


@interface SUGStartMenuViewController () <SUGBeaconReceiverDelegate>

@end

@implementation SUGStartMenuViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SUGTransitionIDForPushTransactionBuddiesAsSugarBaby]) {
        SUGTransactionBuddiesViewController *nextVC = segue.destinationViewController;
        
        id transaction = nil;
        
        nextVC.viewModel = [[SUGTransactionBuddiesViewModel alloc] initWithTransaction:transaction];
        nextVC.sugarDaddy = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [SUGBeaconManager sharedManager].receiver.delegate = self;
    [[SUGBeaconManager sharedManager].receiver startReadingRSSI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[SUGBeaconManager sharedManager].receiver stopReadingRSSI];
}

- (void)startChipInDidTouchUp:(UIButton *)button
{
    [self performSegueWithIdentifier:SUGTransitionIDForPushLatestTransactions sender:nil];
}


#pragma mark - SUGBeaconReceiverDelegate


- (void)beaconPeripheral:(CBPeripheral *)peripheral didUpdateRSSI:(int)RSSI
{
    NSLog(@"%@", peripheral.name);
    
    if (RSSI > SUGStartMenuBeaconThreshold) {
        
        [self performSegueWithIdentifier:SUGTransitionIDForPushTransactionBuddiesAsSugarBaby
                                  sender:nil];
    }
}

@end
