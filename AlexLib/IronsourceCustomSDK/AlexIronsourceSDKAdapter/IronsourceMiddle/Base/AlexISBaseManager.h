
#import <AnyThinkSDK/AnyThinkSDK.h>
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlexISBaseManager : ATNetworkBaseManager

+ (instancetype)sharedManager;

@property (atomic, assign) BOOL isExistBannerAdinfo;


@end


NS_ASSUME_NONNULL_END
