#import <Foundation/Foundation.h>

@class SUGBackendManager;
@protocol SUGBackendManagerDelegate <NSObject>

- (void)backendManager:(SUGBackendManager *)backendManager
          responseObject:(id)response;

@end


@interface SUGBackendManager : NSObject

@property (nonatomic, weak) id <SUGBackendManagerDelegate> delegate;

+ (instancetype)sharedManager;

@property (nonatomic) NSString *deviceID;

- (void)getTransactions;

/// Starts transmitting (sugar daddy)
- (void)createSplitBillWithTransactionID:(NSString*)transactionID;

/// We are done!
- (void)commitSplitBill:(NSString*)billID;

/// do after discover
- (void)joinOpenBillForBeaconWithID:(NSString*)beaconID;

/// you can call periodically to update the transaction.
- (void)pollSplitBill:(NSString*)billID;

@end
