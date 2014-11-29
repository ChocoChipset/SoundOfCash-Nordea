//
//  SUGBuddyViewCell.h
//  SugarBuddy
//
//  Created by Hector Zarate on 11/29/14.
//  Copyright (c) 2014 Hector Zarate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncImageView/AsyncImageView.h>


@interface SUGBuddyViewCell : UICollectionViewCell

@property (nonatomic) IBOutlet UILabel *textLabel;
@property (nonatomic) IBOutlet AsyncImageView *imageView;

@end
