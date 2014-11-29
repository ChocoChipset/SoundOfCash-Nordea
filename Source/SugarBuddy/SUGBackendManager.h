#import <Foundation/Foundation.h>

@interface SUGBackendManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic) NSString *deviceID;

- (NSArray*)getTransactions:(NSString*)accountID;
- (NSDictionary*)createSplitBill:(NSString*)transactionID;
- (NSDictionary*)commitSplitBill:(NSString*)billID;
- (NSDictionary*)discoverSplitBill:(NSArray*)beaconsIDs;
- (NSDictionary*)joinSplitBill:(NSString*)billID withAccount:(NSString*)accountID;
- (NSDictionary*)pollSplitBill:(NSString*)billID;

@end
