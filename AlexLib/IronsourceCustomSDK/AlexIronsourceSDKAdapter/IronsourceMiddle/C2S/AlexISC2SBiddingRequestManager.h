
#import <Foundation/Foundation.h>
#import "AlexISBiddingRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlexISC2SBiddingRequestManager : NSObject

+ (instancetype)sharedInstance;

- (void)startWithRequestItem:(AlexISBiddingRequest *)request;

+ (void)disposeLoadSuccessCall:(NSString *)priceStr customObject:(id)customObject unitID:(NSString *)unitID;

+ (void)disposeLoadFailCall:(NSError *)error key:(NSString *)keyStr unitID:(NSString *)unitID;
@end

NS_ASSUME_NONNULL_END
