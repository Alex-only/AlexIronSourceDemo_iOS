//
//  AlexISRVDelegate.h
//  AnyThinkIronSourceMedationAdapter
//
//  Created by GUO PENG on 2024/9/25.
//  Copyright © 2024 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>
#import "AlexISRewardedVideoCustomEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlexISRVDelegate : NSObject<LevelPlayRewardedVideoDelegate>

+ (instancetype)sharedInstance;

- (void)saveRewardedVideoCustomEvent:(AlexISRewardedVideoCustomEvent *)rewardedVideoCustomEvent;


@end

NS_ASSUME_NONNULL_END
