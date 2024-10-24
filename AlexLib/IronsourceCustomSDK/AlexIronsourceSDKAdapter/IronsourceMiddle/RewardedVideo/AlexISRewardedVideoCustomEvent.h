
#import <AnyThinkRewardedVideo/AnyThinkRewardedVideo.h>
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlexISRewardedVideoCustomEvent : ATRewardedVideoCustomEvent<LevelPlayRewardedVideoDelegate>
@property (atomic, strong) ISAdInfo *adInfo;
@end

NS_ASSUME_NONNULL_END
