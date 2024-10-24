//
//  AlexISBannerCustomEvent.m
//  AnyThinkIronSourceMedationAdapter
//
//  Created by GUO PENG on 2023/7/19.
//  Copyright © 2023 AnyThink. All rights reserved.
//

#import "AlexISBannerCustomEvent.h"
#import "AlexISC2SBiddingRequestManager.h"
#import "AlexISBaseManager.h"


@interface AlexISBannerCustomEvent()
@property (nonatomic, strong) ISAdInfo *adInfo;

@end

@implementation AlexISBannerCustomEvent

- (void)didLoad:(ISBannerView *)bannerView withAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"AlexISBannerCustomEvent---load succeed");
    if (self.isC2SBiding) {
        NSString *price = [NSString stringWithFormat:@"%f",[adInfo.revenue doubleValue] * 1000];
        self.adInfo = adInfo;
        self.ironSbannerView = bannerView;
        [AlexISC2SBiddingRequestManager disposeLoadSuccessCall:price customObject:bannerView unitID:self.networkUnitId];
        self.isC2SBiding = NO;
        return;
    }
    [self trackBannerAdLoaded:bannerView adExtra:nil];
}

- (void)didFailToLoadWithError:(NSError *)error {
    NSLog(@"AlexISBannerCustomEvent---load error:%@",error);

    if (self.isC2SBiding) {
        [AlexISC2SBiddingRequestManager disposeLoadFailCall:error key:kATSDKFailedToLoadBannerADMsg unitID:self.networkUnitId];
        return;
    }
    [self trackBannerAdLoadFailed:error];
}

- (void)didClickWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"AlexISBannerCustomEvent---didClickWithAdInfo");
    [self trackBannerAdClick];
}

- (void)didLeaveApplicationWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"AlexISBannerCustomEvent---didLeaveApplicationWithAdInfo");
}


- (void)didPresentScreenWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"AlexISBannerCustomEvent---didPresentScreenWithAdInfo");
}

- (void)didDismissScreenWithAdInfo:(ISAdInfo *)adInfo {
    NSLog(@"AlexISBannerCustomEvent---didDismissScreenWithAdInfo");
}

- (BOOL)sendImpressionTrackingIfNeed {
    [AlexISBaseManager sharedManager].isExistBannerAdinfo = YES;
    return YES;
}

- (void)destroyBanner {
    [AlexISBaseManager sharedManager].isExistBannerAdinfo = NO;
    [IronSource destroyBanner:self.ironSbannerView];
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
    [customInfo setValue:@"BANNER" forKey:@"Format"];
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
