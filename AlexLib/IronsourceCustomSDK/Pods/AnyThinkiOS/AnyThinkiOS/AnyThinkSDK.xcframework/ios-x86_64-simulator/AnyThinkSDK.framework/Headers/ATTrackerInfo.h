//
//  ATTrackerInfo.h
//  AnyThinkSDK
//
//  Created by GUO PENG on 2023/5/6.
//  Copyright © 2023 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ATClickAreaType) {
    ATClickAreaNOEndCardCTAType = 1,
    ATClickAreaNOEndCardCTAExistClickBannerType = 2,
    ATClickAreaNOEndCardBannerOutSideType = 3,
    ATClickAreaNOEndCardAutoClickType = 4,
    ATClickAreaNOEndCardShakeType = 5,
    ATClickAreaEndCardCTAType = 6,
    ATClickAreaEndCardCTAOutSideType = 7,
    ATClickAreaEndCardAutoClickType = 8,
    ATClickAreaEndCardShakeType = 9,
    ATClickAreaSkoverlyType = 10,
    ATClickAreaShakeBtnType = 11,
    ATClickAreaGuideType = 12,
    ATClickAreaInsensibilityType = 13,
};

@interface ATTrackerInfo : NSObject

@property (nonatomic, assign) ATClickAreaType clickAreaType;

@end

NS_ASSUME_NONNULL_END
