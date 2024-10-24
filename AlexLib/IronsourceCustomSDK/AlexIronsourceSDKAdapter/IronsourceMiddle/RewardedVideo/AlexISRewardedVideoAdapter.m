
#import "AlexISRewardedVideoAdapter.h"
#import "AlexISRewardedVideoCustomEvent.h"
#import <AnyThinkSDK/ATAppSettingManager.h>
#import "AlexISBaseManager.h"
#import <IronSource/IronSource.h>
#import "AlexNetworkC2STool.h"
#import "AlexISRVDelegate.h"
@interface AlexISRewardedVideoAdapter()

@property (nonatomic, strong) AlexISRewardedVideoCustomEvent *customEvent;

@end

@implementation AlexISRewardedVideoAdapter
#pragma mark - init
- (instancetype)initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    self = [super init];
    if (self != nil) {
    }
    return self;
}

#pragma mark - load 
- (void)loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    
    AlexISBiddingRequest *request = [[AlexNetworkC2STool sharedInstance] getRequestItemWithUnitID:serverInfo[@"plid"]];
    self.customEvent = (AlexISRewardedVideoCustomEvent *)request.customEvent;
    self.customEvent.requestCompletionBlock = completion;
    self.customEvent.requestNumber = serverInfo[@"request_num"] ? [serverInfo[@"request_num"] integerValue] : 1;
    
    if ([IronSource hasRewardedVideo]) {
        [self.customEvent trackRewardedVideoAdLoaded:self.customEvent.networkUnitId
                                             adExtra:nil];
    }else {
        [IronSource setLevelPlayRewardedVideoDelegate:[AlexISRVDelegate sharedInstance]];
    }
    [[AlexNetworkC2STool sharedInstance] removeRequestItemWithUnitID:serverInfo[@"plid"]];
}

+ (BOOL)adReadyWithCustomObject:(id)customObject info:(NSDictionary*)info {
    return [IronSource hasRewardedVideo];
}

+ (void)showRewardedVideo:(ATRewardedVideo*)rewardedVideo inViewController:(UIViewController*)viewController delegate:(id<ATRewardedVideoDelegate>)delegate {
    
    AlexISRewardedVideoCustomEvent *customEvent = (AlexISRewardedVideoCustomEvent*)rewardedVideo.customEvent;
    customEvent.delegate = delegate;
    [IronSource showRewardedVideoWithViewController:viewController placement:rewardedVideo.customObject];
}

#pragma mark - C2S
+ (void)bidRequestWithPlacementModel:(ATPlacementModel*)placementModel unitGroupModel:(ATUnitGroupModel*)unitGroupModel info:(NSDictionary*)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    
    [AlexISBaseManager initWithCustomInfo:info localInfo:info];
    
    AlexISRewardedVideoCustomEvent *customEvent = [[AlexISRewardedVideoCustomEvent alloc]initWithInfo:info localInfo:info];
    
    AlexISBiddingRequest *alexRequest = [AlexISBiddingRequest new];
    alexRequest.customEvent = customEvent;
    alexRequest.unitGroup = unitGroupModel;
    alexRequest.placementID = placementModel.placementID;
    alexRequest.bidCompletion = completion;
    alexRequest.unitID = info[@"plid"];
    alexRequest.extraInfo = info;
    alexRequest.adType = ATAdFormatRewardedVideo;
    [[AlexISC2SBiddingRequestManager sharedInstance] startWithRequestItem:alexRequest];
    
}

@end
