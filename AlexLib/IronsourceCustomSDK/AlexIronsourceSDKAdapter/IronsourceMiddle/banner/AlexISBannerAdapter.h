//
//  AlexISBannerAdapter.h
//  AnyThinkIronSourceMedationAdapter
//
//  Created by GUO PENG on 2023/7/19.
//  Copyright © 2023 AnyThink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlexISBannerAdapter : NSObject

+ (ISBannerSize *)proposalSizeToSizeType:(NSString *)sizeStr;
@end

NS_ASSUME_NONNULL_END
