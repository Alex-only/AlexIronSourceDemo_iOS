
#import "AlexISBaseManager.h"
#import <AnyThinkSDK/ATAppSettingManager.h>
#import <IronSource/IronSource.h>

@implementation AlexISBaseManager

+ (void)initWithCustomInfo:(NSDictionary *)serverInfo localInfo:(NSDictionary *)localInfo {
    
    ATUnitGroupModel *unitGroupModel =(ATUnitGroupModel*)serverInfo[kATAdapterCustomInfoUnitGroupModelKey];
    
    [AlexISBaseManager setPersonalizedStateWithUnitGroupModel:unitGroupModel];
    
    [IronSource initWithAppKey:serverInfo[@"sdk_key"] adUnits:@[IS_REWARDED_VIDEO, IS_INTERSTITIAL]];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (![[ATAPI sharedInstance] initFlagForNetwork:kATNetworkNameIronSource]) {
            [[ATAPI sharedInstance] setInitFlagForNetwork:kATNetworkNameIronSource];
            [[ATAPI sharedInstance] setVersion:[IronSource sdkVersion] forNetwork:kATNetworkNameIronSource];
        }
        if ([ATAppSettingManager sharedManager].complyWithCCPA) {
            [IronSource setMetaDataWithKey:@"do_not_sell" value:@"YES"];
        }
        if ([ATAppSettingManager sharedManager].complyWithCOPPA) {
            [IronSource setMetaDataWithKey:@"is_child_directed" value:@"YES"];
        }
    });
}

+ (void)setPersonalizedStateWithUnitGroupModel:(ATUnitGroupModel *)unitGroupModel {
    
    BOOL state = [[ATAPI sharedInstance] getPersonalizedAdState] == ATNonpersonalizedAdStateType ? YES : NO;
    
    BOOL set = NO;
    BOOL limit = [[ATAppSettingManager sharedManager] limitThirdPartySDKDataCollection:&set networkFirmID:unitGroupModel.networkFirmID];
    
    if (state || (set && limit)) {
        [IronSource setConsent:NO];
    } else {
        [IronSource setConsent:YES];
    }
}


@end
