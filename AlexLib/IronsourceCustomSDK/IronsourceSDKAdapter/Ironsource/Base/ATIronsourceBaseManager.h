//
//  ATIronsourceBaseManager.h
//  AnyThinkIronSourceAdapter
//
//  Created by Topon on 11/16/20.
//  Copyright © 2020 AnyThink. All rights reserved.
//

#import <AnyThinkSDK/AnyThinkSDK.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, ATATFBBKBidderType) {
    ATATFBBKBidderType_FackBook,
    ATATFBBKBidderType_IronSource
};

typedef NS_ENUM(NSInteger, ATATFBBKIronSourceAdBidFormat) {
    ATATFBBKIronSourceAdBidFormatInterstitial,
    ATATFBBKIronSourceAdBidFormatRewardedVideo
};

@interface ATIronsourceBaseManager : ATNetworkBaseManager

@end


@protocol ATBaseIronSource<NSObject>
+ (void)setConsent:(BOOL)consent;
+ (NSString *)sdkVersion;
+ (BOOL)setDynamicUserId:(NSString *)dynamicUserId;
+ (void)initISDemandOnly:(NSString *)appKey adUnits:(NSArray<NSString *> *)adUnits;

+ (void)setMetaDataWithKey:(NSString *)key value:(NSString *)value;
+ (NSString *) getISDemandOnlyBiddingData;
@end

NS_ASSUME_NONNULL_END
