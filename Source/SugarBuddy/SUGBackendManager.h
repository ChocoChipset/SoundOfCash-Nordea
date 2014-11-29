#import <Foundation/Foundation.h>

@interface SUGBackendManager : NSObject

+ (instancetype)sharedManager;

- (NSArray*)getTransactions;
- (NSDictionary*)createSplitBill:(NSString*)transactionID;
- (NSDictionary*)commitSplitBill:(NSString*)billID;
- (NSDictionary*)discoverSplitBill:(NSArray*)beaconsIDs;
- (NSDictionary*)joinSplitBill:(NSString*)billID;

@end
