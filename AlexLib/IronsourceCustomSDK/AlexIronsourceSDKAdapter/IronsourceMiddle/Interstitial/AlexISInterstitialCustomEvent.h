
#import <AnyThinkInterstitial/AnyThinkInterstitial.h>
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlexISInterstitialCustomEvent : ATInterstitialCustomEvent<LevelPlayInterstitialDelegate>
@property (nonatomic, strong) ISAdInfo *adInfo;
@end

NS_ASSUME_NONNULL_END
