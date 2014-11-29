#import <Foundation/Foundation.h>

@interface SUGBackendManager : NSObject

+ (instancetype)sharedManager;

- (void)getTransactions;

@end
