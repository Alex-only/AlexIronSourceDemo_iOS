
#import "AlexISInterstitialAdapter.h"
#import "AlexISInterstitialCustomEvent.h"
#import <AnyThinkSDK/ATAppSettingManager.h>
#import "AlexISBaseManager.h"
#import <IronSource/IronSource.h>
#import <AnyThinkSDK/AnyThinkSDK.h>


NSString *const kAlexIronSourceInterstitialNotificationLoaded = @"com.alex.kAlexIronSourceInterstitialNotificationLoaded";
NSString *const kAlexIronSourceInterstitialNotificationLoadFailed = @"com.alex.kAlexIronSourceInterstitialNotificationLoadFailed";
NSString *const kAlexIronSourceInterstitialNotificationShow = @"com.alex.kAlexIronSourceInterstitialNotificationShow";
NSString *const kAlexIronSourceInterstitialNotificationClick = @"com.alex.kAlexIronSourceInterstitialNotificationClick";
NSString *const kAlexIronSourceInterstitialNotificationClose = @"com.alex.kAlexIronSourceInterstitialNotificationClose";

NSString *const kAlexIronSourceInterstitialNotificationUserInfoInstanceID = @"instance_id";
NSString *const kAlexIronSourceInterstitialNotificationUserInfoError = @"error";

@interface ATIronSourceInterstitialDelegate:NSObject<ISDemandOnlyInterstitialDelegate>
@end

@implementation ATIronSourceInterstitialDelegate
+(instancetype) sharedDelegate {
    static ATIronSourceInterstitialDelegate *sharedDelegate = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDelegate = [[ATIronSourceInterstitialDelegate alloc] init];
    });
    return sharedDelegate;
}
#pragma mark - demand only
- (void)interstitialDidLoad:(NSString *)instanceId {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAlexIronSourceInterstitialNotificationLoaded object:nil userInfo:@{kAlexIronSourceInterstitialNotificationUserInfoInstanceID:instanceId != nil ? instanceId : @""}];
}

- (void)interstitialDidFailToLoadWithError:(NSError *)error instanceId:(NSString *)instanceId {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAlexIronSourceInterstitialNotificationLoadFailed object:nil userInfo:@{kAlexIronSourceInterstitialNotificationUserInfoInstanceID:instanceId != nil ? instanceId : @"", kAlexIronSourceInterstitialNotificationUserInfoError:error != nil ? error : [NSError errorWithDomain:@"com.alex.IronSrouceInterstitialLoading" code:10001 userInfo:@{NSLocalizedDescriptionKey:@"AnyThinkSDK has failed to load interstitial ad", NSLocalizedFailureReasonErrorKey:@"IronSource has failed to load interstitial ad."}]}];
}

- (void)interstitialDidOpen:(NSString *)instanceId {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAlexIronSourceInterstitialNotificationShow object:nil userInfo:@{kAlexIronSourceInterstitialNotificationUserInfoInstanceID:instanceId != nil ? instanceId : @""}];
}

- (void)interstitialDidClose:(NSString *)instanceId {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAlexIronSourceInterstitialNotificationClose object:nil userInfo:@{kAlexIronSourceInterstitialNotificationUserInfoInstanceID:instanceId != nil ? instanceId : @""}];
}

- (void)interstitialDidFailToShowWithError:(NSError *)error instanceId:(NSString *)instanceId {
    
}

- (void)didClickInterstitial:(NSString *)instanceId {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAlexIronSourceInterstitialNotificationClick object:nil userInfo:@{kAlexIronSourceInterstitialNotificationUserInfoInstanceID:instanceId != nil ? instanceId : @""}];
}
@end

@interface AlexISInterstitialAdapter()
@property(nonatomic, readonly) AlexISInterstitialCustomEvent *customEvent;
@end

static NSString *const kPlacementNameKey = @"placement_name";
@implementation AlexISInterstitialAdapter
+(BOOL) adReadyWithCustomObject:(NSString*)customObject info:(NSDictionary*)info {
    return [IronSource hasISDemandOnlyInterstitial:customObject];;
}

+(void) showInterstitial:(ATInterstitial*)interstitial inViewController:(UIViewController*)viewController delegate:(id<ATInterstitialDelegate>)delegate {
    interstitial.customEvent.delegate = delegate;
    [(AlexISInterstitialCustomEvent *)interstitial.customEvent registerNotification];
    [IronSource showISDemandOnlyInterstitial:viewController instanceId:interstitial.customObject];
}

-(instancetype) initWithNetworkCustomInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo {
    self = [super init];
    if (self != nil) {
        [AlexISBaseManager initWithCustomInfo:serverInfo localInfo:localInfo];
    }
    return self;
}

-(void) loadADWithInfo:(NSDictionary*)serverInfo localInfo:(NSDictionary*)localInfo completion:(void (^)(NSArray<NSDictionary *> *, NSError *))completion {
    
    _customEvent = [[AlexISInterstitialCustomEvent alloc] initWithInfo:serverInfo localInfo:localInfo];
    _customEvent.requestNumber = [serverInfo[@"request_num"] integerValue];
    _customEvent.requestCompletionBlock = completion;
    
    NSString *bidId = serverInfo[kATAdapterCustomInfoBuyeruIdKey];

    [IronSource setISDemandOnlyInterstitialDelegate:[ATIronSourceInterstitialDelegate sharedDelegate]];
    if (bidId) {
        [IronSource loadISDemandOnlyInterstitialWithAdm:serverInfo[@"instance_id"] adm:bidId];
    } else {
        [IronSource loadISDemandOnlyInterstitial:serverInfo[@"instance_id"]];
    }
}

+(void)headerBiddingParametersWithUnitGroupModel:(ATUnitGroupModel*)unitGroupModel extra:(NSDictionary *)extra completion:(void(^)(NSDictionary *headerBiddingParams))completion {
    
    [AlexISBaseManager initWithCustomInfo:unitGroupModel.content localInfo:@{}];
    NSString *biddingToken = [IronSource getISDemandOnlyBiddingData];
    if (!biddingToken) {
        completion(nil);
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:unitGroupModel.content[@"instance_id"] != nil ? unitGroupModel.content[@"instance_id"] : @"" forKey:kATHeaderBiddingParametersUnitIdKey];
    [params setValue:biddingToken forKey:kATHeaderBiddingParametersBuyeruIdKey];
    [params setValue:@(ATATFBBKBidderType_IronSource) forKey:kATHeaderBiddingParametersBidderTypeKey];
    [params setValue:@(ATATFBBKIronSourceAdBidFormatInterstitial) forKey:kATHeaderBiddingParametersBidFormatKey];
    completion(params);
}
@end
