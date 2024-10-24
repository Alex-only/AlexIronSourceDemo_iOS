//
//  AlexISBannerCustomEvent.h
//  AnyThinkIronSourceMedationAdapter
//
//  Created by GUO PENG on 2023/7/19.
//  Copyright © 2023 AnyThink. All rights reserved.
//

#import <AnyThinkBanner/AnyThinkBanner.h>
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlexISBannerCustomEvent : ATBannerCustomEvent<LevelPlayBannerDelegate>
@property (nonatomic, strong) ISBannerView *ironSbannerView;
@end

NS_ASSUME_NONNULL_END
