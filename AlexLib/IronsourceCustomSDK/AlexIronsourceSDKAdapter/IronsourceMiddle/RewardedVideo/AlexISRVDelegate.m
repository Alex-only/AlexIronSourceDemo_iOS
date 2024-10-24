//
//  AlexISRVDelegate.m
//  AnyThinkIronSourceMedationAdapter
//
//  Created by GUO PENG on 2024/9/25.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import "AlexISRVDelegate.h"


@interface AlexISRVDelegate()

@property (nonatomic, strong) NSMutableArray <AlexISRewardedVideoCustomEvent *>*rvCustomEventArray;

@property (nonatomic, strong) NSMutableDictionary *adInFoDic;

@end

@implementation AlexISRVDelegate

+ (instancetype)sharedInstance {
    static AlexISRVDelegate *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AlexISRVDelegate alloc] init];
        sharedManager.rvCustomEventArray = [NSMutableArray array];
        sharedManager.adInFoDic = [NSMutableDictionary dictionary];

    });
    return sharedManager;
}

- (void)saveRewardedVideoCustomEvent:(AlexISRewardedVideoCustomEvent *)rewardedVideoCustomEvent {
    if (rewardedVideoCustomEvent) {
        [self.rvCustomEventArray addObject:rewardedVideoCustomEvent];
    }
    [self.adInFoDic.allValues enumerateObjectsUsingBlock:^(ISAdInfo  *adInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!rewardedVideoCustomEvent.adInfo) {
            rewardedVideoCustomEvent.adInfo = adInfo;
        }
    }];
}

- (void)removeRewardedVideoCustomEvent:(AlexISRewardedVideoCustomEvent *)rewardedVideoCustomEvent {
    [self.rvCustomEventArray removeObject:rewardedVideoCustomEvent];
}

- (void)checkAdInfoAvailable:(ISAdInfo *)adInfo {
    __block BOOL isUse = NO;
    [self.rvCustomEventArray enumerateObjectsUsingBlock:^(AlexISRewardedVideoCustomEvent *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.adInfo) {
            obj.adInfo = adInfo;
            isUse = YES;
        }
    }];
    if (!isUse) {
        if (adInfo && adInfo.auction_id) {
            [self.adInFoDic setValue:adInfo forKey:adInfo.auction_id];
        }
    }
}

#pragma mark - LevelPlayRewardedVideoDelegate
- (void)hasAvailableAdWithAdInfo:(ISAdInfo *)adInfo {
    [self checkAdInfoAvailable:adInfo];
}

- (void)hasNoAvailableAd {
    
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {
    [self.rvCustomEventArray enumerateObjectsUsingBlock:^(AlexISRewardedVideoCustomEvent *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([adInfo.auction_id isEqualToString:obj.adInfo.auction_id]) {
            [obj trackRewardedVideoAdRewarded];
        }
    }];
}

- (void)didFailToShowWithError:(NSError *)error andAdInfo:(ISAdInfo *)adInfo {

    [self.rvCustomEventArray enumerateObjectsUsingBlock:^(AlexISRewardedVideoCustomEvent *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([adInfo.auction_id isEqualToString:obj.adInfo.auction_id]) {
            [obj trackRewardedVideoAdPlayEventWithError:error];
        }
    }];
    
    
}


- (void)didOpenWithAdInfo:(ISAdInfo *)adInfo {
    [self.rvCustomEventArray enumerateObjectsUsingBlock:^(AlexISRewardedVideoCustomEvent *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([adInfo.auction_id isEqualToString:obj.adInfo.auction_id]) {
            [obj trackRewardedVideoAdShow];
            [obj trackRewardedVideoAdVideoStart];
        }
    }];

}


- (void)didClick:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {
    [self.rvCustomEventArray enumerateObjectsUsingBlock:^(AlexISRewardedVideoCustomEvent *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([adInfo.auction_id isEqualToString:obj.adInfo.auction_id]) {
            [obj trackRewardedVideoAdClick];
        }
    }];
}

- (void)didCloseWithAdInfo:(ISAdInfo *)adInfo {
    
    [self.adInFoDic removeObjectForKey:adInfo.auction_id];
    
    __block AlexISRewardedVideoCustomEvent *customEvent;
    [self.rvCustomEventArray enumerateObjectsUsingBlock:^(AlexISRewardedVideoCustomEvent *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([adInfo.auction_id isEqualToString:obj.adInfo.auction_id]) {
            [obj trackRewardedVideoAdVideoEnd];
            [obj trackRewardedVideoAdCloseRewarded:obj.rewardGranted extra:@{kATADDelegateExtraDismissTypeKey:@(ATAdCloseUnknow)}];
            customEvent = obj;
        }
    }];
    [self removeRewardedVideoCustomEvent:customEvent];
}

@end
