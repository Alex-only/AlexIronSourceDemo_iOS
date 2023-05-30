
#import "AlexISRewardedVideoCustomEvent.h"

@implementation AlexISRewardedVideoCustomEvent


- (void)hasAvailableAdWithAdInfo:(ISAdInfo *)adInfo {
    self.adInfo = adInfo;
}

- (void)hasNoAvailableAd {
    self.adapter = nil;
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {
    [self trackRewardedVideoAdRewarded];    
}

- (void)didFailToShowWithError:(NSError *)error andAdInfo:(ISAdInfo *)adInfo {
    [self trackRewardedVideoAdPlayEventWithError:error];
}


- (void)didOpenWithAdInfo:(ISAdInfo *)adInfo {
    [self trackRewardedVideoAdShow];
    [self trackRewardedVideoAdVideoStart];
}


- (void)didClick:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {
    [self trackRewardedVideoAdClick];
}

- (void)didCloseWithAdInfo:(ISAdInfo *)adInfo {
    [self trackRewardedVideoAdVideoEnd];
    [self trackRewardedVideoAdCloseRewarded:self.rewardGranted extra:@{kATADDelegateExtraDismissTypeKey:@(ATAdCloseUnknow)}];
}

- (NSString *)networkUnitId {
    return self.serverInfo[@"plid"];
}
@end
