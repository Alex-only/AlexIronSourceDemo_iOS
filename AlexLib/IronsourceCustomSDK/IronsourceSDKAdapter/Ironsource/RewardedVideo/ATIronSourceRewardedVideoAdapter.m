//
//  ATIronSourceRewardedVideoAdapter.m
//  AnyThinkIronSourceRewardedVideoAdapter
//
//  Created by Martin Lau on 09/07/2018.
//  Copyright © 2018 Martin Lau. All rights reserved.
//

#import "ATIronSourceRewardedVideoAdapter.h"
#import "ATIronSourceRewardedVideoCustomEvent.h"
#import <AnyThinkSDK/ATAppSettingManager.h>
#import "ATIronsourceBaseManager.h"
#import <IronSource/IronSource.h>


NSString *const kATIronSourceRVNotificationLoaded = @"com.anythink.kATIronSourceRVNotificationLoaded";
NSString *const kATIronSourceRVNotificationLoadFailed = @"com.anythink.kATIronSourceRVNotificationLoadFailed";
NSString *const kATIronSourceRVNotificationShow = @"com.anythink.kATIronSourceRVNotificationShow";
NSString *const kATIronSourceRVNotificationShowFailed = @"kATIronSourceRVNotificationShowFailed";
NSString *const kATIronSourceRVNotificationClick = @"com.anythink.kATIronSourceRVNotificationClick";
NSString *const kATIronSourceRVNotificationReward = @"com.anythink.kATIronSourceRVNotificationReward";
NSString *const kATIronSourceRVNotificationClose = @"com.anythink.kATIronSourceRVNotificationClose";

NSString *const kATIronSourceRVNotificationUserInfoInstanceIDKey = @"instance_id";
NSString *const kATIronSourceRVNotificationUserInfoErrorKey = @"error";
@interface ATIronSrouceRewardedVideoDelegate:NSObject<ISDemandOnlyRewardedVideoDelegate>
@end

@implementation ATIronSrouceRewardedVideoDelegate
+(instancetype) sharedDelegate {
    static ATIronSrouceRewardedVideoDelegate *sharedDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDelegate = [[ATIronSrouceRewardedVideoDelegate alloc] init];
    });
    return sharedDelegate;
}

- (void)rewardedVideoDidLoad:(NSString *)instanceId {
    [[NSNotificationCenter defaultCenter] postNotificationName:kATIronSourceRVNotificationLoaded object:nil userInfo:@{kATIronSourceRVNotificationUserInfoInstanceIDKey:instanceId != nil ? instanceId : @""}];
}

- (void)rewardedVideoDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId {
    [[NSNotificationCenter defaultCenter] postNotificationName:kATIronSourceRVNotificationLoadFailed object:nil userInfo:@{kATIronSourceRVNotificationUserInfoInstanceIDKey:instanceId != nil ? instanceId : @"", kATIronSourceRVNotificationUserInfoErrorKey:error != nil ? error : [NSError errorWithDomain:@"com.anythink.IronSrouceRewardedVideoLoading" code:10001 userInfo:@{NSLocalizedDescriptionKey:@"AnyThinkSDK has failed to load rewarded video ad", NSLocalizedFailureReasonErrorKey:@"IronSource has failed to load rewarded video ad."}]}];
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kATIronSourceRVNotificationShowFailed object:nil userInfo:@{kATIronSourceRVNotificationUserInfoInstanceIDKey:instanceId != nil ? instanceId : @"", kATIronSourceRVNotificationUserInfoErrorKey:error != nil ? error : [NSError errorWithDomain:@"com.anythink.IronSrouceRewardedVideoShow" code:10001 userInfo:@{NSLocalizedDescriptionKey:@"AnyThinkSDK has failed to show rewarded video ad", NSLocalizedFailureReasonErrorKey:@"IronSource has failed to show rewarded video ad."}]}];
}

- (void)rewardedVideoDidOpen:(NSString *)instanceId {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kATIronSourceRVNotificationShow object:nil userInfo:@{kATIronSourceRVNotificationUserInfoInstanceIDKey:instanceId != nil ? instanceId : @""}];
}

- (void)rewardedVideoDidClose:(NSString *)instanceId {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kATIronSourceRVNotificationClose object:nil userInfo:@{kATIronSourceRVNotificationUserInfoInstanceIDKey:instanceId != nil ? instanceId : @""}];
}

- (void)rewardedVideoAdRewarded:(NSString *)instanceId { 
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kATIronSourceRVNotificationReward object:nil userInfo:@{kATIronSourceRVNotificationUserInfoInstanceIDKey:instanceId != nil ? instanceId : @""}];
}


- (void)rewardedVideoDidClick:(NSString *)instanceId { 
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kATIronSourceRVNotificationClick object:nil userInfo:@{kATIronSourceRVNotificationUserInfoInstanceIDKey:instanceId != nil ? instanceId : @""}];
}
@end

@interface ATIronSourceRewardedVideoAdapter()
@property(nonatomic, readonly) ATIronSourceRewardedVideoCustomEvent *customEvent;
@end

static NSString *const kUnitIDKey = @"unit_id";
static NSString *const kPlacementNameKey = @"placement_name";
@implementation ATIronSourceRewardedVideoAdapter

+(BOOL) adReadyWithCustomObject:(id)customObject info:(NSDictionary*)info {
    return [IronSource hasISDemandOnlyRewardedVideo:customObject];
}

+(void) showRewardedVideo:(ATRewardedVideo*)rewardedVideo inViewController:(UIViewController*)viewController delegate:(id<ATRewardedVideoDelegate>)delegate {
    ATIronSourceRewardedVideoCustomEvent *customEvent = (ATIronSourceRewardedVideoCustomEvent*)rewardedVideo.customEvent;
    customEvent.delegate = delegate;
    [customEvent registerNotification];
    [IronSource showISDemandOnlyRewardedVideo:viewController instanceId:customEvent.unitID];
}

-(instancetype) initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    self = [super init];
    if (self != nil) {
        [ATIronsourceBaseManager initWithCustomInfo:serverInfo localInfo:localInfo];
    }
    return self;
}

-(void) loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {

    _customEvent = [[ATIronSourceRewardedVideoCustomEvent alloc] initWithUnitID:serverInfo[@"instance_id"] serverInfo:serverInfo localInfo:localInfo];
    _customEvent.requestNumber = [serverInfo[@"request_num"] integerValue];
    _customEvent.requestCompletionBlock = completion;
    
    NSString *bidId = serverInfo[kATAdapterCustomInfoBuyeruIdKey];

    if (localInfo[kATAdLoadingExtraUserIDKey] != nil) {
        [IronSource setDynamicUserId:localInfo[kATAdLoadingExtraUserIDKey]];
    }
    [IronSource setISDemandOnlyRewardedVideoDelegate:[ATIronSrouceRewardedVideoDelegate sharedDelegate]];
    
    if (bidId) {
        [IronSource loadISDemandOnlyRewardedVideoWithAdm:serverInfo[@"instance_id"] adm:bidId];
    } else {
        [IronSource loadISDemandOnlyRewardedVideo:serverInfo[@"instance_id"]];
    }
}

+(void)headerBiddingParametersWithUnitGroupModel:(ATUnitGroupModel*)unitGroupModel extra:(NSDictionary *)extra completion:(void(^)(NSDictionary *headerBiddingParams))completion {
    
    [ATIronsourceBaseManager initWithCustomInfo:unitGroupModel.content localInfo:@{}];
    NSString *biddingToken = [IronSource getISDemandOnlyBiddingData];
    if (!biddingToken) {
        completion(nil);
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:unitGroupModel.content[@"instance_id"] != nil ? unitGroupModel.content[@"instance_id"] : @"" forKey:kATHeaderBiddingParametersUnitIdKey];
    [params setValue:biddingToken forKey:kATHeaderBiddingParametersBuyeruIdKey];
    [params setValue:@(ATATFBBKBidderType_IronSource) forKey:kATHeaderBiddingParametersBidderTypeKey];
    [params setValue:@(ATATFBBKIronSourceAdBidFormatRewardedVideo) forKey:kATHeaderBiddingParametersBidFormatKey];
    completion(params);
} 
@end
