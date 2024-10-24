
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

- (NSDictionary *)networkCustomInfo {
    
    NSMutableDictionary *customInfo = [[NSMutableDictionary alloc] init];
    [customInfo setValue:self.adInfo.lifetime_revenue forKey:@"LifeTimeRevenue"];
    [customInfo setValue:self.adInfo.revenue forKey:@"Revenue"];
    [customInfo setValue:self.adInfo.ad_unit forKey:@"AdUnitId"];
    [customInfo setValue:self.adInfo.instance_id forKey:@"CreativeId"];
    [customInfo setValue:@"REWARDED" forKey:@"Format"];
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
