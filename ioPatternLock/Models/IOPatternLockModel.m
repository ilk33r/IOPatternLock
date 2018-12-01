//
//  IOPatternLockModel.m
//  IOPatternLock
//
//  Created by Ilker OZCAN on 27.11.2018.
//  Copyright © 2018 Ilker OZCAN. All rights reserved.
//

#import "IOPatternLockModel.h"

@implementation IOPatternLockModel

+ (instancetype)modelWithPoint:(CGPoint)point index:(NSUInteger)index {
	IOPatternLockModel *model = [IOPatternLockModel new];
	model.x = point.x;
	model.y = point.y;
	model.isActive = NO;
	model.index = index;
	
	return model;
}

- (id)copy {
	IOPatternLockModel *model = [IOPatternLockModel new];
	model.x = self.x;
	model.y = self.y;
	model.isActive = self.isActive;
	model.index = self.index;
	
	return model;
}

@end
