//
//  IOPatternLockModel.h
//  IOPatternLock
//
//  Created by Ilker OZCAN on 27.11.2018.
//  Copyright © 2018 Ilker OZCAN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IOPatternLockModel : NSObject

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) NSUInteger index;

+ (instancetype)modelWithPoint:(CGPoint)point index:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
