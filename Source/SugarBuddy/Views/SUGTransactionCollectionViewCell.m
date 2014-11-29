//
//  SUGTransactionCollectionViewCell.m
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import "SUGTransactionCollectionViewCell.h"

@implementation SUGTransactionCollectionViewCell

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.backgroundColor = (highlighted ? [UIColor SUGWhiteColor] : [UIColor SUGBlueBackgroundColor]);
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.backgroundColor = (selected ? [UIColor SUGWhiteColor] : [UIColor SUGBlueBackgroundColor]);
}

@end
