//
//  ATBidInfoCacheManager.h
//  AnyThinkSDK
//
//  Created by Martin Lau on 2020/4/28.
//  Copyright © 2020 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATBidInfo.h"

#define ATHeaderBiddingListKey @"headerBiddingList"
#define ATHbParmeterErrorsKey @"hbParmeterErrors"
#define ATCurrentUnitGroupsKey @"currentUnitGroups"

@class ATUnitGroupModel;
@class ATPlacementModel;
@class ATBidWaterFallModel;
@class ATBidNotifSendModel;
@class ATWaterfall;
//@class ATWinLossSendTool;

typedef NS_ENUM(NSUInteger, ATLossType) {
    ATLossAdExpiteType = 1,
    ATLossAdCheckCacheType,
    ATLossAdWaterFallFinshType,
};

typedef void(^StartBidBlock)(NSDictionary * headerBiddingListDic);

@interface ATBidInfoCacheManager : NSObject

+ (instancetype)sharedManager;
/**
 Used for renew bidinfo
 */
- (void)saveRequestID:(NSString*)requestID forPlacementID:(NSString*)placementID;
- (NSString*)requestForPlacementID:(NSString*)placementID;

- (void)saveBidInfo:(ATBidInfo*)bidInfo;
- (void)invalidateBidInfoForPlacementID:(NSString*)placementID unitGroupModel:(ATUnitGroupModel*)unitGroupModel;
- (ATBidInfo*)getBidInfoCachedForPlacementID:(NSString*)placementID unitGroup:(ATUnitGroupModel*)unitGroup;
- (BOOL)checkAdxBidInfoExpireForPlacementID:(NSString*)placementID unitGroupModel:(ATUnitGroupModel*)unitGroupModel;

- (NSArray<ATUnitGroupModel*>*)unitGroupWithHistoryBidInfoAvailableForPlacementID:(NSString*)placementID unitGroups:(NSArray<ATUnitGroupModel*>*)unitGroupsToInspect inhouseUnitGroups:(NSArray<ATUnitGroupModel*>*)inhouseUnitGroupsToInspect s2sUnitGroups:(NSArray<ATUnitGroupModel*>*)s2sUnitGroupsToInspect bksUnitGroups:(NSArray<ATUnitGroupModel*>*)bksUnitGroupsToInspect  directUnitGroups:(NSArray<ATUnitGroupModel*>*)directUnitGroups requestID:(NSString*)requestID;

/**
 Used for send hb loss notification
 */
- (BOOL)saveWithBidNotifSendModel:(ATBidNotifSendModel*)bidNotifSendModel forRequestID:(NSString*)requestID;
- (ATBidNotifSendModel*)getBidNotifSendModelForRequestID:(NSString*)requestID;

- (void)saveNoPriceCacheWitBidWaterFallModel:(ATBidWaterFallModel*)bidWaterfallModel;
- (void)removeNoPriceCacheWithTpBidId:(NSString*)tpBidId unitId:(NSString*)unitId;
- (ATBidWaterFallModel *)getBidWaterFallModelWithTpBidId:(NSString*)tpBidId unitId:(NSString*)unitId;


/// send hb win nontification and save event
- (void)sendHBWinNotificationAndSaveEventWithPlacementID:(NSString *)placementID
                                               requestID:(NSString *)requestID
                                               unitGroup:(ATUnitGroupModel *)unitGroup
                                          finalWaterfall:(ATWaterfall *)finalWaterfall;

- (void)sendHBLossNotificationForPlacementID:(NSString*)placementID requestID:(NSString*)requestID unitGroups:(NSArray<ATUnitGroupModel*>*)unitGroups;
- (void)sendNotifyDisplayForPlacementID:(NSString*)placementID unitGroup:(ATUnitGroupModel*)unitGroup winner:(BOOL)isWinner headerBidding:(BOOL)headerBidding price:(NSString *)price;

// send hb loss notification
- (void)sendHBLossNotificationForBidInfo:(ATBidInfo *)bidInfo price:(NSString*)price headerBidding:(BOOL)headerBidding winnerNetworkFirmID:(NSInteger)winnerNetworkFirmID requestID:(NSString*)requestID lossType:(ATLossType)losstype;

/// send loss when hb adsource expite
- (void)sendLossNotificationForHBExpiredAdSourceWithUnitGroup:(ATUnitGroupModel *)unitGroup
                                                  placementID:(NSString*)placementID
                                                requestID:(NSString *)requestID;

+ (NSString *)getPriceToSendHBNotifiForUnitGroup:(ATUnitGroupModel*)unitGroupModel;
+ (NSString *)getSortPriorityPriceToSendHBNotifiForUnitGroup:(ATUnitGroupModel*)unitGroupModel;
+ (NSString *)priceForBidInfo:(ATBidInfo*)bidInfo;

//6.1.42
- (ATUnitGroupModel *)checkSendWinIfNeedWhenWaterFallFinishWithRequestId:(NSString *)requestID placementID:(NSString *)placementID;


#pragma mark - bid List
- (void)saveBidRequestHBList:(NSDictionary *)hbListExtra forKeyStr:(NSString *)keyStr;
- (NSDictionary *)getBidRequestHbListForKeyStr:(NSString *)keyStr;

@end
