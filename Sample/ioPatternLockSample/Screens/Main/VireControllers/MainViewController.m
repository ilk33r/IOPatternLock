//
//  MainViewController.m
//  ioPatternLockSample
//
//  Created by Ilker OZCAN on 27.11.2018.
//  Copyright © 2018 Ilker OZCAN. All rights reserved.
//

#import <IOPatternLock/IOPatternLock.h>
#import "MainViewController.h"

@interface MainViewController () <IOPatternLockDelegate>

@property (nonatomic, weak) IBOutlet IOPatternLockView *patternLockView;

@end

@implementation MainViewController

#pragma mark - Pattern Lock Delegate

- (void)IOPatternLockView:(IOPatternLockView *)patternLockView patternCompleted:(NSArray<NSNumber *> *)selectedPatterns {
	NSLog(@"Pattern completed.\nSelected patterns %@", selectedPatterns);
}

- (void)IOPatternLockView:(IOPatternLockView *)patternLockView patternCompletedWithError:(NSError *)error {
	NSLog(@"Pattern error.\n%@", error.localizedDescription);
	[patternLockView redraw];
}

@end
