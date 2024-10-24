
#import "AlexISInterstitialCustomEvent.h"
#import "AlexISC2SBiddingRequestManager.h"

@interface AlexISInterstitialCustomEvent()



@end

@implementation AlexISInterstitialCustomEvent
 
- (void)didLoadWithAdInfo:(ISAdInfo *)adInfo {
    self.adInfo = adInfo;
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

- (NSDictionary *)networkCustomInfo {
    NSMutableDictionary *customInfo = [[NSMutableDictionary alloc] init];
    [customInfo setValue:self.adInfo.lifetime_revenue forKey:@"LifeTimeRevenue"];
    [customInfo setValue:self.adInfo.revenue forKey:@"Revenue"];
    [customInfo setValue:self.adInfo.ad_unit forKey:@"AdUnitId"];
    [customInfo setValue:self.adInfo.instance_id forKey:@"CreativeId"];
    [customInfo setValue:@"Interstitial" forKey:@"Format"];
    [customInfo setValue:self.adInfo.ad_network forKey:@"AdNetwork"];
    [customInfo setValue:@"IronSourceMediation" forKey:@"NetworkName"];
    [customInfo setValue:self.adInfo.segment_name forKey:@"NetworkPlacement"];
    [customInfo setValue:self.adInfo.country forKey:@"CountryCode"];
    [customInfo setValue:self.adInfo.encrypted_cpm forKey:@"EncryptedCpm"];
    [customInfo setValue:self.adInfo.conversion_value forKey:@"ConversionValue"];
    [customInfo setValue:self.adInfo.ab forKey:@"AB"];
    return customInfo;
}

@end
