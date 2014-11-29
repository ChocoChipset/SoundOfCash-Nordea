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
- (void)createSplitBill:(NSString*)transactionID;
- (void)commitSplitBill:(NSString*)billID;
- (void)discoverSplitBill:(NSArray*)beaconsIDs;
- (void)joinSplitBill:(NSString*)billID withAccount:(NSString*)accountID;
- (void)pollSplitBill:(NSString*)billID;

@end
