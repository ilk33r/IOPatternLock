//
//  IOPointsModel.m
//  IOPatternLock
//
//  Created by Ilker OZCAN on 1.12.2018.
//  Copyright © 2018 Ilker OZCAN. All rights reserved.
//

#import "IOPointsModel.h"

@implementation IOPointsModel

+ (instancetype)pointsWithStartX:(CGFloat)startX
						  startY:(CGFloat)startY
							endX:(CGFloat)endX
							endY:(CGFloat)endY {
	// Create a model
	IOPointsModel *pointsModel = [IOPointsModel new];
	pointsModel.p1 = CGPointMake(startX, startY);
	pointsModel.p2 = CGPointMake(endX, endY);
	
	return pointsModel;
}

@end
