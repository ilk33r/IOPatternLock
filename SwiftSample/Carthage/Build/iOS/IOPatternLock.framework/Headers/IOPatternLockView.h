//
//  IOPatternLockView.h
//  IOPatternLock
//
//  Created by Ilker OZCAN on 27.11.2018.
//  Copyright © 2018 Ilker OZCAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IOPatternLockDelegate;

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface IOPatternLockView : UIView

@property (nonatomic, assign) IBInspectable NSInteger column;
@property (nonatomic, assign) IBInspectable NSInteger minimumNumberOfSelections;
@property (nonatomic, assign) IBInspectable NSInteger row;

@property (nonatomic, assign) IBInspectable NSUInteger borderWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) IBInspectable NSUInteger circleSpace UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) IBInspectable NSUInteger innerCirclePadding UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) IBInspectable NSUInteger lineWidth UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) IBInspectable UIColor *activeBorderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) IBInspectable UIColor *activeInnerCircleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) IBInspectable UIColor *borderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) IBInspectable UIColor *innerCircleColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) IBInspectable UIColor *lineColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, weak) IBOutlet id<IOPatternLockDelegate> delegate;

#pragma mark - Helper Methods

- (void)redraw;

@end

NS_ASSUME_NONNULL_END
