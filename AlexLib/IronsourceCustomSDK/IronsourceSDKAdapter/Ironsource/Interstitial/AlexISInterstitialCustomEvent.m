

#import "AlexISInterstitialCustomEvent.h"



@implementation AlexISInterstitialCustomEvent
-(instancetype) initWithInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
    self = [super initWithInfo:serverInfo localInfo:localInfo];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoaded:) name:kAlexIronSourceInterstitialNotificationLoaded object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoadFailed:) name:kAlexIronSourceInterstitialNotificationLoadFailed object:nil];

    }
    return self;
}

-(void) registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleClose:) name:kAlexIronSourceInterstitialNotificationClose object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleClick:) name:kAlexIronSourceInterstitialNotificationClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShow:) name:kAlexIronSourceInterstitialNotificationShow object:nil];

}

-(void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) handleLoaded:(NSNotification*)notification {
    if ([notification.userInfo[kAlexIronSourceInterstitialNotificationUserInfoInstanceID] isEqualToString:self.unitID]) {
        [self trackInterstitialAdLoaded:self.networkUnitId adExtra:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlexIronSourceInterstitialNotificationLoaded object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlexIronSourceInterstitialNotificationLoadFailed object:nil];
    }
}

-(void) handleLoadFailed:(NSNotification*)notification {
    if ([notification.userInfo[kAlexIronSourceInterstitialNotificationUserInfoInstanceID] isEqualToString:self.unitID]) {
        NSError *error = notification.userInfo[kAlexIronSourceInterstitialNotificationUserInfoError];
        [self trackInterstitialAdLoadFailed:error != nil ? error : [NSError errorWithDomain:@"com.alex.IronSourceInterstitialLoading" code:100001 userInfo:@{NSLocalizedDescriptionKey:@"AnyThinkSDK has failed to load interstitial", NSLocalizedFailureReasonErrorKey:@"IronSource has failed to load interstitial"}]];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlexIronSourceInterstitialNotificationLoaded object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlexIronSourceInterstitialNotificationLoadFailed object:nil];
    }
}

-(void) handleShow:(NSNotification*)notification {
    if ([notification.userInfo[kAlexIronSourceInterstitialNotificationUserInfoInstanceID] isEqualToString:self.unitID] && self.interstitial != nil) {
        [self trackInterstitialAdShow];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlexIronSourceInterstitialNotificationShow object:nil];
    }
}

-(void) handleClick:(NSNotification*)notification {
    if ([notification.userInfo[kAlexIronSourceInterstitialNotificationUserInfoInstanceID] isEqualToString:self.unitID] && self.interstitial != nil) {
        [self trackInterstitialAdClick];
    }
}

-(void) handleClose:(NSNotification*)notification {
    if ([notification.userInfo[kAlexIronSourceInterstitialNotificationUserInfoInstanceID] isEqualToString:self.unitID] && self.interstitial != nil) {
        [self trackInterstitialAdClose:@{kATADDelegateExtraDismissTypeKey:@(ATAdCloseUnknow)}];

        [[NSNotificationCenter defaultCenter] removeObserver:self name:kAlexIronSourceInterstitialNotificationClose object:nil];
    }
}

- (NSString *)networkUnitId {
    return self.serverInfo[@"instance_id"];
}

@end
