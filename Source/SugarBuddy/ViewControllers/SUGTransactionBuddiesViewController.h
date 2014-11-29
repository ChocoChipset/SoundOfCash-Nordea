#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SUGTransactionBuddiesViewModel;

@interface SUGTransactionBuddiesViewController : UIViewController

@property (nonatomic, getter=isSugarDaddy) BOOL sugarDaddy;

@property (nonatomic) SUGTransactionBuddiesViewModel *viewModel;
@property (nonatomic) NSString *transactionID;

@end
