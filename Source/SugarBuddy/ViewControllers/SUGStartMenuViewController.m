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
#import "NSString+Hashing.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

const NSInteger SUGStartMenuBeaconThreshold = -30;


@interface SUGStartMenuViewController () <SUGBeaconReceiverDelegate>
@property (nonatomic) IBOutlet UIImageView *topDownStackLower;
@property (nonatomic) IBOutlet UIImageView *topDownStackupper;
@property (nonatomic) SystemSoundID audioOfCashSound;
@end

@implementation SUGStartMenuViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSString *)peripheral
{
    if ([segue.identifier isEqualToString:SUGTransitionIDForPushTransactionBuddiesAsSugarBaby]) {
        SUGTransactionBuddiesViewController *nextVC = segue.destinationViewController;
        nextVC.beaconID = peripheral;
        nextVC.sugarDaddy = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [SUGBeaconManager sharedManager].receiver.delegate = self;
    [[SUGBeaconManager sharedManager].receiver startReadingRSSI];
    
    CGPoint originalCenter = [[self topDownStackupper ] center];
    CGPoint offScreen = CGPointMake(originalCenter.x+100, originalCenter.y-20);
    [self topDownStackupper].center = offScreen;
    [self topDownStackupper].alpha = 0.8;
    
    [UIView beginAnimations:@"stack-upper" context:nil];
    [UIView setAnimationDuration:2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationRepeatCount:INFINITY];
    [UIView setAnimationRepeatAutoreverses:YES];
    [self topDownStackupper].center = originalCenter;
    [self topDownStackupper].alpha = 1.0;
    [UIView commitAnimations];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[SUGBeaconManager sharedManager].receiver stopReadingRSSI];
}

- (void)startChipInDidTouchUp:(UIButton *)button
{
    [self performSegueWithIdentifier:SUGTransitionIDForPushLatestTransactions sender:nil];
}

#pragma mark - IBACtions

- (IBAction)soundButtonDidTouchUpInside:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSString *pewPewPath = [[NSBundle mainBundle]
                                pathForResource:@"sound-of-cash" ofType:@"mp3"];
        NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &_audioOfCashSound);
        AudioServicesPlaySystemSound(self.audioOfCashSound);
    });
}




#pragma mark - SUGBeaconReceiverDelegate


- (void)beaconPeripheral:(NSString *)peripheral didUpdateRSSI:(int)RSSI
{
    NSLog(@"Peripheral %@. RSSI: %d", peripheral, RSSI);
    
    if (RSSI > SUGStartMenuBeaconThreshold) {
        
        [self performSegueWithIdentifier:SUGTransitionIDForPushTransactionBuddiesAsSugarBaby
                                  sender:peripheral];
    }
}

@end
