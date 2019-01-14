//
//  IOPatternLockDelegate.h
//  IOPatternLock
//
//  Created by Ilker OZCAN on 1.12.2018.
//  Copyright © 2018 Ilker OZCAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOPatternLockView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IOPatternLockDelegate <NSObject>

- (void)IOPatternLockView:(IOPatternLockView *)patternLockView patternCompleted:(NSArray<NSNumber *> *)selectedPatterns;
- (void)IOPatternLockView:(IOPatternLockView *)patternLockView patternCompletedWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
