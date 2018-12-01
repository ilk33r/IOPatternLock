//
//  IOCGRectUtilities.m
//  IOPatternLock
//
//  Created by Ilker OZCAN on 1.12.2018.
//  Copyright © 2018 Ilker OZCAN. All rights reserved.
//

#import "IOCGRectUtilities.h"
#import "IOPatternLockModel.h"

@implementation IOCGRectUtilities

CGPoint CGPointCenterOfCircle(CGFloat circleSize, IOPatternLockModel *circle) {
	CGFloat center = circleSize / 2;
	return CGPointMake(circle.x + center, circle.y + center);
}

+ (IOPointsModel *)getLinePointsFromCircles:(IOPatternLockModel *)from toCircle:(IOPatternLockModel *)to circleSize:(CGFloat)circleSize borderWidth:(CGFloat)borderWidth {
	// Check y values is equal
	if (from.y == to.y) {
		// return side by side positions
		return [self getPointsForSideBySide:from toCircle:to circleSize:circleSize];
	}
	else if (from.x == to.x) {
		// return side by side positions
		return [self getPointsForUpsideDown:from toCircle:to circleSize:circleSize];
	}
	else if (from.y < to.y) {
		// return side by side positions
		return [self getPointsForDownCross:from toCircle:to circleSize:circleSize borderWidth:borderWidth];
	}
	else if (from.y > to.y) {
		// return side by side positions
		return [self getPointsForUpCross:from toCircle:to circleSize:circleSize borderWidth:borderWidth];
	}
	
	return nil;
}

#pragma mark - Portrait / Landscape Position

+ (IOPointsModel *)getPointsForSideBySide:(IOPatternLockModel *)from toCircle:(IOPatternLockModel *)to circleSize:(CGFloat)circleSize {
	// Calculate y position
	CGFloat yPosition = from.y + (circleSize / 2);
	
	// Check direction is left to right
	if (from.x < to.x) {
		return [IOPointsModel pointsWithStartX:from.x + circleSize startY:yPosition endX:to.x endY:yPosition];
	}
	else if (from.x > to.x) {
		return [IOPointsModel pointsWithStartX:to.x + circleSize startY:yPosition endX:from.x endY:yPosition];
	}
	
	return nil;
}

+ (IOPointsModel *)getPointsForUpsideDown:(IOPatternLockModel *)from toCircle:(IOPatternLockModel *)to circleSize:(CGFloat)circleSize {
	// Calculate y position
	CGFloat xPosition = from.x + (circleSize / 2);
	
	// Check direction is top to bottom
	if (from.y < to.y) {
		return [IOPointsModel pointsWithStartX:xPosition startY:from.y + circleSize endX:xPosition endY:to.y];
	}
	else if (from.y > to.y) {
		return [IOPointsModel pointsWithStartX:xPosition startY:from.y endX:xPosition endY:to.y + circleSize];
	}
	
	return nil;
}

#pragma mark - Cross Positions

+ (IOPointsModel *)getPointsForDownCross:(IOPatternLockModel *)from toCircle:(IOPatternLockModel *)to circleSize:(CGFloat)circleSize borderWidth:(CGFloat)borderWidth {
	// Obtain circle radius
	CGFloat circleRadius = circleSize / 2;
	CGFloat borderDifference = borderWidth * 2;
	
	// Obtain start angle
	CGFloat angle = [self degreeToRadians:45];
	
	// Calculate point x and y const
	CGFloat constX = circleRadius * cos(angle);
	CGFloat constY = circleRadius * sin(angle);
	
	// Check direction is left to right
	if (from.x < to.x) {
		// Obtain radians value
		CGFloat xStartPosition = constX + from.x + circleRadius - borderDifference;
		CGFloat yStartPosition = constY + from.y + circleRadius + borderDifference;
		
		CGFloat xEndPosition = to.x - constX + circleRadius + borderDifference;
		CGFloat yEndPosition = to.y - constY + circleRadius - borderDifference;
		
		return [IOPointsModel pointsWithStartX:xStartPosition startY:yStartPosition endX:xEndPosition endY:yEndPosition];
	}
	else if (from.x > to.x) {
		// Obtain radians value
		CGFloat xStartPosition = from.x - constX + circleRadius + borderDifference;
		CGFloat yStartPosition = from.y + constY + circleRadius + borderDifference;
		
		CGFloat xEndPosition = to.x + constX + circleRadius - borderDifference;
		CGFloat yEndPosition = to.y - constY + circleRadius - borderDifference;
		
		return [IOPointsModel pointsWithStartX:xStartPosition startY:yStartPosition endX:xEndPosition endY:yEndPosition];
	}
	
	return nil;
}

+ (IOPointsModel *)getPointsForUpCross:(IOPatternLockModel *)from toCircle:(IOPatternLockModel *)to circleSize:(CGFloat)circleSize borderWidth:(CGFloat)borderWidth {
	// Obtain circle radius
	CGFloat circleRadius = circleSize / 2;
	CGFloat borderDifference = borderWidth * 2;
	
	// Obtain start angle
	CGFloat angle = [self degreeToRadians:45];
	
	// Calculate point x and y const
	CGFloat constX = circleRadius * cos(angle);
	CGFloat constY = circleRadius * sin(angle);
	
	// Check direction is left to right
	if (from.x < to.x) {
		// Obtain radians value
		CGFloat xStartPosition = from.x + constX + circleRadius - borderDifference;
		CGFloat yStartPosition = from.y - constY + circleRadius - borderDifference;
		
		CGFloat xEndPosition = to.x - constX + circleRadius + borderDifference;
		CGFloat yEndPosition = to.y + constY + circleRadius + borderDifference;
		
		return [IOPointsModel pointsWithStartX:xStartPosition startY:yStartPosition endX:xEndPosition endY:yEndPosition];
	}
	else if (from.x > to.x) {
		// Obtain radians value
		CGFloat xStartPosition = from.x - constX + circleRadius + borderDifference;
		CGFloat yStartPosition = from.y - constY + circleRadius - borderDifference;
		
		CGFloat xEndPosition = to.x + constX + circleRadius - borderDifference;
		CGFloat yEndPosition = to.y + constY + circleRadius + borderDifference;
		
		return [IOPointsModel pointsWithStartX:xStartPosition startY:yStartPosition endX:xEndPosition endY:yEndPosition];
	}
	
	return nil;
}

+ (CGFloat)degreeToRadians:(CGFloat)degree {
	return (degree * M_PI) / 180;
}

@end
