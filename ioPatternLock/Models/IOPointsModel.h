//
//  IOPointsModel.h
//  IOPatternLock
//
//  Created by Ilker OZCAN on 1.12.2018.
//  Copyright © 2018 Ilker OZCAN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IOPointsModel : NSObject

@property (nonatomic, assign) CGPoint p1;
@property (nonatomic, assign) CGPoint p2;

+ (instancetype)pointsWithStartX:(CGFloat)startX
						  startY:(CGFloat)startY
							endX:(CGFloat)endX
							endY:(CGFloat)endX;

@end

NS_ASSUME_NONNULL_END
