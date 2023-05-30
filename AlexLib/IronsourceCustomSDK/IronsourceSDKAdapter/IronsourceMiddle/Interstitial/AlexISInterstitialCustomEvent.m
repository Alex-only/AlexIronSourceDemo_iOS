
#import "AlexISInterstitialCustomEvent.h"
#import "AlexISC2SBiddingRequestManager.h"

@implementation AlexISInterstitialCustomEvent

- (void)didLoadWithAdInfo:(ISAdInfo *)adInfo {
    
    NSString *price = [NSString stringWithFormat:@"%f",[adInfo.revenue doubleValue] * 1000];
    [AlexISC2SBiddingRequestManager disposeLoadSuccessCall:price customObject:adInfo unitID:self.networkUnitId];
}

- (void)didFailToLoadWithError:(NSError *)error {
    [AlexISC2SBiddingRequestManager disposeLoadFailCall:error key:kATSDKFailedToLoadInterstitialADMsg unitID:self.networkUnitId];
}

- (void)didOpenWithAdInfo:(ISAdInfo *)adInfo {
     
}

- (void)didShowWithAdInfo:(ISAdInfo *)adInfo {
    [self trackInterstitialAdShow];
}

- (void)didFailToShowWithError:(NSError *)error andAdInfo:(ISAdInfo *)adInfo {
    [self trackInterstitialAdShowFailed:error];
}

- (void)didClickWithAdInfo:(ISAdInfo *)adInfo {
    [self trackInterstitialAdClick];
}

- (void)didCloseWithAdInfo:(ISAdInfo *)adInfo {
    [self trackInterstitialAdClose:@{kATADDelegateExtraDismissTypeKey:@(ATAdCloseUnknow)}];
}

- (NSString *)networkUnitId {
    return self.serverInfo[@"plid"];
}
@end
