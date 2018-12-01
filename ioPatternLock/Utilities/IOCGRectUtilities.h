//
//  IOCGRectUtilities.h
//  IOPatternLock
//
//  Created by Ilker OZCAN on 1.12.2018.
//  Copyright © 2018 Ilker OZCAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOPointsModel.h"

@class IOPatternLockModel;

NS_ASSUME_NONNULL_BEGIN

@interface IOCGRectUtilities : NSObject

CGPoint CGPointCenterOfCircle(CGFloat circleSize, IOPatternLockModel *circle);

+ (IOPointsModel *)getLinePointsFromCircles:(IOPatternLockModel *)from toCircle:(IOPatternLockModel *)to circleSize:(CGFloat)circleSize borderWidth:(CGFloat)borderWidth;

@end

NS_ASSUME_NONNULL_END
