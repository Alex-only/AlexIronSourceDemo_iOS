
#import "AlexISInterstitialAdapter.h"
#import "AlexISInterstitialCustomEvent.h"
#import <AnyThinkSDK/ATAppSettingManager.h>
#import "AlexISBaseManager.h"
#import <IronSource/IronSource.h>
#import <AnyThinkSDK/AnyThinkSDK.h>
#import "AlexNetworkC2STool.h"



@interface AlexISInterstitialAdapter()
@property(nonatomic, strong) AlexISInterstitialCustomEvent *customEvent;
@end


@implementation AlexISInterstitialAdapter
#pragma mark - init
- (instancetype) initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    self = [super init];
    if (self != nil) {
    }
    return self;
}
#pragma mark - load
- (void)loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    
    AlexISBiddingRequest *request = [[AlexNetworkC2STool sharedInstance] getRequestItemWithUnitID:serverInfo[@"plid"]];
    self.customEvent = (AlexISInterstitialCustomEvent *)request.customEvent;
    self.customEvent.requestCompletionBlock = completion;
    self.customEvent.requestNumber = serverInfo[@"request_num"] ? [serverInfo[@"request_num"] integerValue] : 1;

    if ([IronSource hasInterstitial]) {
        [self.customEvent trackInterstitialAdLoaded:self.customEvent.networkUnitId adExtra:nil];
    }else {
        [IronSource setLevelPlayInterstitialDelegate:self.customEvent];
        [IronSource loadInterstitial];
    }
    [[AlexNetworkC2STool sharedInstance] removeRequestItemWithUnitID:serverInfo[@"plid"]];
}

+ (BOOL)adReadyWithCustomObject:(NSString*)customObject info:(NSDictionary*)info {
    return [IronSource hasInterstitial];
}

+ (void)showInterstitial:(ATInterstitial*)interstitial inViewController:(UIViewController*)viewController delegate:(id<ATInterstitialDelegate>)delegate {
    
    interstitial.customEvent.delegate = delegate;
    [IronSource showInterstitialWithViewController:viewController placement:interstitial.customObject];
}

#pragma mark - C2S
+ (void)bidRequestWithPlacementModel:(ATPlacementModel*)placementModel unitGroupModel:(ATUnitGroupModel*)unitGroupModel info:(NSDictionary*)info completion:(void(^)(ATBidInfo *bidInfo, NSError *error))completion {
    
    [AlexISBaseManager initWithCustomInfo:info localInfo:info];

    AlexISInterstitialCustomEvent *customEvent = [[AlexISInterstitialCustomEvent alloc]initWithInfo:info localInfo:info];
    
    AlexISBiddingRequest *alexRequest = [AlexISBiddingRequest new];
    alexRequest.customEvent = customEvent;
    alexRequest.unitGroup = unitGroupModel;
    alexRequest.placementID = placementModel.placementID;
    alexRequest.bidCompletion = completion;
    alexRequest.unitID = info[@"plid"];
    alexRequest.extraInfo = info;
    alexRequest.adType = ATAdFormatInterstitial;
    [[AlexISC2SBiddingRequestManager sharedInstance] startWithRequestItem:alexRequest];
}

@end
