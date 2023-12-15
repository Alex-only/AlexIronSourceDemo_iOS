
#import "AlexISC2SBiddingRequestManager.h"
#import "AlexISBiddingRequest.h"
#import <IronSource/IronSource.h>
#import "AlexISInterstitialCustomEvent.h"
#import "AlexNetworkC2STool.h"
#import "AlexISRewardedVideoCustomEvent.h"

@interface AlexISC2SBiddingRequestManager()

@property(nonatomic) dispatch_source_t timer;

@end

@implementation AlexISC2SBiddingRequestManager
#pragma mark - init
+ (instancetype)sharedInstance {
    static AlexISC2SBiddingRequestManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AlexISC2SBiddingRequestManager alloc] init];
    });
    return sharedInstance;
}

#pragma mark - public
- (void)startWithRequestItem:(AlexISBiddingRequest *)request {
    
    [[AlexNetworkC2STool sharedInstance] saveRequestItem:request withUnitId:request.unitID];
    
    switch (request.adType) {
        case ATAdFormatInterstitial:
            [self startLoadInterstitialAdWithRequest:request];
            break;
            
        case ATAdFormatRewardedVideo:
            [self startLoadRewardedVideoAdWithRequest:request];
            break;
        default:
            break;
    }
    
}

#pragma mark - ATAdFormatInterstitial
- (void)startLoadInterstitialAdWithRequest:(AlexISBiddingRequest *)request {
    [IronSource setLevelPlayInterstitialDelegate:(AlexISInterstitialCustomEvent *)request.customEvent];
    [IronSource loadInterstitial];
}

#pragma mark - ATAdFormatRewardedVideo
- (void)startLoadRewardedVideoAdWithRequest:(AlexISBiddingRequest *)request {
    [IronSource setLevelPlayRewardedVideoDelegate:(AlexISRewardedVideoCustomEvent *)request.customEvent];
    [self checkReadyAfterSeconds:request];
}

int seconds = 0;
- (void)checkReadyAfterSeconds:(AlexISBiddingRequest *)request {
    
    AlexISRewardedVideoCustomEvent *rewardedVideoCustomEvent = (AlexISRewardedVideoCustomEvent *)request.customEvent;
    
    dispatch_source_set_event_handler(self.timer, ^{
        seconds += 2;
        BOOL has = [IronSource hasRewardedVideo];
        if (has) {
            NSString *price = [NSString stringWithFormat:@"%f",[rewardedVideoCustomEvent.adInfo.revenue doubleValue] * 1000];
            [AlexISC2SBiddingRequestManager disposeLoadSuccessCall:price customObject:rewardedVideoCustomEvent.adInfo unitID:rewardedVideoCustomEvent.networkUnitId];
            dispatch_source_cancel(self.timer);
            self.timer = nil;
            return;
        }
        
        if (seconds >= 16 && has == NO) {
            dispatch_source_cancel(self.timer);
            self.timer = nil;
            NSError *error = [NSError errorWithDomain:@"com.ofmIronsource.rewardedVideo" code:509 userInfo:@{NSLocalizedFailureReasonErrorKey:@"No ads to show"}];
            [AlexISC2SBiddingRequestManager disposeLoadFailCall:error key:kATSDKFailedToLoadInterstitialADMsg unitID:rewardedVideoCustomEvent.networkUnitId];
        }
    });
    dispatch_resume(self.timer);
}

#pragma mark - create C2S bidinfo
+ (void)disposeLoadSuccessCall:(NSString *)priceStr customObject:(id)customObject unitID:(NSString *)unitID {
    
    if ([priceStr doubleValue] < 0) {
        priceStr = @"0";
    }
    AlexISBiddingRequest *request = [[AlexNetworkC2STool sharedInstance] getRequestItemWithUnitID:unitID];
    request.price = priceStr;
    
    if (request == nil) {
        return;
    }
    
    ATBidInfo *bidInfo = [ATBidInfo bidInfoC2SWithPlacementID:request.placementID unitGroupUnitID:request.unitGroup.unitID adapterClassString:request.unitGroup.adapterClassString price:priceStr currencyType:ATBiddingCurrencyTypeUS expirationInterval:request.unitGroup.bidTokenTime customObject:customObject];
    bidInfo.networkFirmID = request.unitGroup.networkFirmID;
    if (request.bidCompletion) {
        request.bidCompletion(bidInfo, nil);
    }
}

+ (void)disposeLoadFailCall:(NSError *)error key:(NSString *)keyStr unitID:(NSString *)unitID {
    
    AlexISBiddingRequest *request = [[AlexNetworkC2STool sharedInstance] getRequestItemWithUnitID:unitID];
    
    if (request == nil) {
        return;
    }
    if (request.bidCompletion) {
        request.bidCompletion(nil, [NSError errorWithDomain:@"com.AlexISSDK.AlexISSDK" code:error.code userInfo:@{
            NSLocalizedDescriptionKey:keyStr,
            NSLocalizedFailureReasonErrorKey:error}]);
    }
    
    [[AlexNetworkC2STool sharedInstance] removeRequestItemWithUnitID:unitID];
}

#pragma mark - lazy
- (dispatch_source_t)timer {
    if (_timer == nil) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    }
    return _timer;
}

@end
