#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (priceAsString)
@property (nonatomic, readonly) NSString *priceAsString;
@end
