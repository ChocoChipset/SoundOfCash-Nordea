//
//  SUGStartMenuViewController.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGStartMenuViewController.h"
#import "SUGLatestTransactionsViewController.h"


@implementation SUGStartMenuViewController


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SUGTransitionIDForPushLatestTransactions]) {
        SUGLatestTransactionsViewController *nextVC = segue.destinationViewController;
    }
}

-(void)joinChipInDidTouchUp:(UIButton *)button
{
    [[SUGBeaconManager sharedManager].broadcaster startBroadCasting];
}

- (void)startChipInDidTouchUp:(UIButton *)button
{
    [self performSegueWithIdentifier:SUGTransitionIDForPushLatestTransactions sender:nil];
}

@end
