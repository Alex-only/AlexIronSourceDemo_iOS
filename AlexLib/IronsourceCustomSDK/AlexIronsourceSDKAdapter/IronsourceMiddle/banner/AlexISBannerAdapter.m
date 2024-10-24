//
//  AlexISBannerAdapter.m
//  AnyThinkIronSourceMedationAdapter
//
//  Created by GUO PENG on 2023/7/19.
//  Copyright © 2023 AnyThink. All rights reserved.
//

#import "AlexISBannerAdapter.h"
#import <AnyThinkSDK/ATAppSettingManager.h>
#import "AlexISBaseManager.h"
#import <AnyThinkSDK/AnyThinkSDK.h>
#import "AlexNetworkC2STool.h"
#import "AlexISBannerCustomEvent.h"

@interface AlexISBannerAdapter()
@property(nonatomic, strong) AlexISBannerCustomEvent *customEvent;
@property(nonatomic, strong) NSDictionary *localInfo;
@property(nonatomic, strong) NSDictionary *serverInfo;
@end

@implementation AlexISBannerAdapter
- (instancetype) initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    self = [super init];
    if (self != nil) {
        [AlexISBaseManager initWithCustomInfo:serverInfo localInfo:localInfo];
    }
    return self;
}

- (void)loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    
    self.localInfo = localInfo;
    self.serverInfo = serverInfo;
    
   
    
    
    NSString *bidId = serverInfo[kATAdapterCustomInfoBuyeruIdKey];
    // c2s
    if (bidId) {
        [self loadc2sAdWithCompletion:completion];
        return;
    }
    
    if ([[AlexISBaseManager sharedManager] isExistBannerAdinfo]) {
        NSError *error = [NSError errorWithDomain:@"com.IronSrouceBannerLoading" code:10001 userInfo:@{NSLocalizedDescriptionKey:@"failed to load Banner ad.Has cache, failed to load.", NSLocalizedFailureReasonErrorKey:@"IronSource has failed to load Banner ad."}];
        AlexISBannerCustomEvent *customEvent = [[AlexISBannerCustomEvent alloc]initWithInfo:serverInfo localInfo:localInfo];
        customEvent.requestCompletionBlock = completion;
        [customEvent trackBannerAdLoadFailed:error];
        return;
    }
    // 常规
    self.customEvent = [[AlexISBannerCustomEvent alloc]initWithInfo:serverInfo localInfo:localInfo];
    self.customEvent.requestCompletionBlock = completion;
    self.customEvent.requestNumber = self.serverInfo[@"request_num"] ? [self.serverInfo[@"request_num"] integerValue] : 1;
    [self loadISAd];
}

- (void)loadc2sAdWithCompletion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion  {
    
    AlexISBiddingRequest *request = [[AlexNetworkC2STool sharedInstance] getRequestItemWithUnitID:self.serverInfo[@"plid"]];
    self.customEvent = (AlexISBannerCustomEvent *)request.customEvent;
    self.customEvent.requestCompletionBlock = completion;
    self.customEvent.requestNumber = self.serverInfo[@"request_num"] ? [self.serverInfo[@"request_num"] integerValue] : 1;
    
    if (self.customEvent.ironSbannerView) {
        [self.customEvent trackBannerAdLoaded:self.customEvent.ironSbannerView adExtra:nil];
    }else {
        [self loadISAd];
    }
    [[AlexNetworkC2STool sharedInstance] removeRequestItemWithUnitID:self.serverInfo[@"plid"]];
}

- (void)loadISAd {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [IronSource setLevelPlayBannerDelegate:self.customEvent];
        ISBannerSize *bannerSize = [AlexISBannerAdapter proposalSizeToSizeType:self.serverInfo[@"size"]];
        UIViewController *rootViewController =  [ATBannerCustomEvent rootViewControllerWithPlacementID:((ATPlacementModel*)self.serverInfo[kATAdapterCustomInfoPlacementModelKey]).placementID requestID:self.serverInfo[kATAdapterCustomInfoRequestIDKey]];

        [IronSource loadBannerWithViewController:rootViewController size:bannerSize];
        
    });
}

+ (ISBannerSize *)proposalSizeToSizeType:(NSString *)sizeStr {
    if ([sizeStr isEqualToString:@"320x50"]) {
        return ISBannerSize_BANNER;
    } else if ([sizeStr isEqualToString:@"320x90"]) {
        return ISBannerSize_LARGE;
    }  else if ([sizeStr isEqualToString:@"300x250"]) {
        return ISBannerSize_RECTANGLE;
    }  else if ([sizeStr isEqualToString:@"0x0"]) {
        return ISBannerSize_SMART;
    }else if ([sizeStr isEqualToString:@"728x90"]) {
        return ISBannerSize_LEADERBOARD;
    } else {
        return ISBannerSize_BANNER;
    }
}

#pragma mark - C2S
+ (void)bidRequestWithPlacementModel:(ATPlacementModel*)placementModel unitGroupModel:(ATUnitGroupModel*)unitGroupModel info:(NSDictionary*)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    
    
    if ([[AlexISBaseManager sharedManager] isExistBannerAdinfo]) {
        
        NSError *error = [NSError errorWithDomain:@"com.IronSrouceBannerLoading" code:10001 userInfo:@{NSLocalizedDescriptionKey:@"failed to load Banner ad.Has cache, failed to load.", NSLocalizedFailureReasonErrorKey:@"IronSource has failed to load Banner ad."}];
        completion(nil,error);
        return;
    }
    
    [AlexISBaseManager initWithCustomInfo:info localInfo:info];

    AlexISBannerCustomEvent *customEvent = [[AlexISBannerCustomEvent alloc]initWithInfo:info localInfo:info];
    customEvent.isC2SBiding = YES;
    AlexISBiddingRequest *alexRequest = [AlexISBiddingRequest new];
    alexRequest.customEvent = customEvent;
    alexRequest.unitGroup = unitGroupModel;
    alexRequest.placementID = placementModel.placementID;
    alexRequest.bidCompletion = completion;
    alexRequest.unitID = info[@"plid"];
    alexRequest.extraInfo = info;
    alexRequest.adType = ATAdFormatBanner;
    [[AlexISC2SBiddingRequestManager sharedInstance] startWithRequestItem:alexRequest];
}

@end
