//
//  IOPatternLockView.m
//  IOPatternLock
//
//  Created by Ilker OZCAN on 27.11.2018.
//  Copyright © 2018 Ilker OZCAN. All rights reserved.
//

#import "IOCGRectUtilities.h"
#import "IOPatternLockDelegate.h"
#import "IOPatternLockModel.h"
#import "IOPatternLockView.h"

@implementation IOPatternLockView {
	CGFloat _circleSize;
	CGPoint _endPoint;
	CGRect _drawedRect;
	NSMutableArray<IOPatternLockModel *> *_circlePoints;
	NSMutableArray<IOPatternLockModel *> *_selectedCircles;
	NSInteger _startCirclePatternIndex;
}

@synthesize column = _column;
@synthesize minimumNumberOfSelections = _minimumNumberOfSelections;
@synthesize row = _row;
@synthesize borderWidth = _borderWidth;
@synthesize circleSpace = _circleSpace;
@synthesize innerCirclePadding = _innerCirclePadding;
@synthesize lineWidth = _lineWidth;
@synthesize activeBorderColor = _activeBorderColor;
@synthesize activeInnerCircleColor = _activeInnerCircleColor;
@synthesize borderColor = _borderColor;
@synthesize innerCircleColor = _innerCircleColor;
@synthesize lineColor = _lineColor;

#pragma mark - Constants

NSString * const IOPatternLockErrorDomain = @"com.ilkerozcan.IOPatternLock";

#pragma mark - Initialization Methods

- (instancetype)init {
	self = [super init];
	if (self) {
		[self initializeProperties];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initializeProperties];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initializeProperties];
	}
	return self;
}

- (void)initializeProperties {
	// Set properties with default values
	_column = 3;
	_minimumNumberOfSelections = 3;
	_row = 3;
	_borderWidth = 1;
	_circleSpace = 24;
	_innerCirclePadding = 20;
	_lineWidth = 4;
	_activeBorderColor = [UIColor blueColor];
	_activeInnerCircleColor = [UIColor blueColor];
	_borderColor = [UIColor darkGrayColor];
	_innerCircleColor = [UIColor darkGrayColor];
	_lineColor = [UIColor blueColor];
	
	// Update gesture status
	_endPoint = CGPointZero;
	_circleSize = 0;
	_drawedRect = CGRectZero;
	_startCirclePatternIndex = -1;
	
	// Add gesture recognizer to view
#ifndef TARGET_INTERFACE_BUILDER
	UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc
												  ] initWithTarget:self action:@selector(handlePan:)];
	[self addGestureRecognizer:gestureRecognizer];
#endif
}

#pragma mark - View Lifecycle

- (void)layoutSubviews {
	[super layoutSubviews];
	[self setNeedsDisplay];
}

#pragma mark - Drawing Methods

- (void)drawRect:(CGRect)rect {
	// Obtain drawing context
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Check rect is equal
	if (!CGRectEqualToRect(rect, _drawedRect)) {
		// Update drawed rect
		_drawedRect = rect;
		
		// Clear circle points
		_circlePoints = [NSMutableArray new];
		_selectedCircles = [NSMutableArray new];
	}
	
	// Draw circles
	[self drawCirclesToRect:rect context:context];
	
	// Draw lines
	[self drawLinesToContext:context];
	
	// Push context
	UIGraphicsPushContext(context);
}

- (void)drawCirclesToRect:(CGRect)rect context:(CGContextRef)context {
	// Obtain area width
	CGFloat drawAreaWidth = rect.size.width;
	CGFloat circleSpaceSize = (_column - 1.0f) * _circleSpace;
	_circleSize = (drawAreaWidth - circleSpaceSize) / _column;
	CGFloat innerCircleSize = _circleSize - (_innerCirclePadding * 2);
	
	// Create a path
	CGPoint point = CGPointMake(rect.origin.x, rect.origin.y);
	
	// Obtain point index
	NSInteger pointIndex = 0;
	
	// Loop throught rows
	for (NSInteger currentRow = 0; currentRow < _row; currentRow++) {
		// Loop throught columns
		for (NSInteger currentColumn = 0; currentColumn < _column; currentColumn++) {
			// Create outher circle rect
			CGRect circlePathRect = CGRectMake(point.x, point.y, _circleSize, _circleSize);
			
			// Create circle model
			IOPatternLockModel *pointModel;
			
			// Check point is inserted before
			if (_circlePoints.count <= pointIndex) {
				// Then add point to array
				pointModel = [IOPatternLockModel modelWithPoint:point index:pointIndex];
				[_circlePoints addObject:pointModel];
			}
			else {
				// Obtain point model
				pointModel = [_circlePoints objectAtIndex:pointIndex];
			}
			
			// Create circle
			UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circlePathRect];
			
			// Check point is active
			if (pointModel.isActive) {
				// Set stroke color
				CGContextSetStrokeColorWithColor(context, _activeBorderColor.CGColor);
			}
			else {
				// Set stroke color
				CGContextSetStrokeColorWithColor(context, _borderColor.CGColor);
			}
			
			// Stroke path
			[circlePath stroke];
			
			// Update point
			point.x += _innerCirclePadding;
			point.y += _innerCirclePadding;
			
			// Create inner circle rect
			CGRect innerCirclePathRect = CGRectMake(point.x, point.y, innerCircleSize, innerCircleSize);
			
			// Create inner circle
			UIBezierPath *innerCirclePath = [UIBezierPath bezierPathWithOvalInRect:innerCirclePathRect];
			
			// Check point is active
			if (pointModel.isActive) {
				// Set stroke color
				CGContextSetFillColorWithColor(context, _activeInnerCircleColor.CGColor);
			}
			else {
				// Set stroke color
				CGContextSetFillColorWithColor(context, _innerCircleColor.CGColor);
			}
			
			// Fill inner circle
			[innerCirclePath fill];
			
			// Update point
			point.x -= _innerCirclePadding;
			point.y -= _innerCirclePadding;
			point.x += _circleSize + _circleSpace;
			
			// Update index
			pointIndex += 1;
		}
		
		// Update point
		point.x = 0;
		point.y += _circleSize + circleSpaceSize;
	}
}

- (void)drawLinesToContext:(CGContextRef)context {
	// Check line count is more than equal to 3
	if (_selectedCircles.count >= 2) {
		// Loop throught lines
		for (NSUInteger i = 0; i < _selectedCircles.count; i++) {
			// Obtain next index
			NSUInteger nextIndex = i + 1;
			
			// Check next line exists
			if (_selectedCircles.count <= nextIndex) {
				// Break the loop
				break;
			}
			
			// Obtain circles
			IOPatternLockModel *from = [_selectedCircles objectAtIndex:i];
			IOPatternLockModel *to = [_selectedCircles objectAtIndex:nextIndex];
			
			// Check from and to circle is same
			if (from.index == to.index) {
				// Do nothing
				continue;
			}
			
			// Obtain points
			IOPointsModel *points = [IOCGRectUtilities getLinePointsFromCircles:from toCircle:to circleSize:_circleSize borderWidth:_borderWidth];
			
			// Draw lines
			[self drawLinesToContext:context withPoints:points];
		}
	}
	
	if (_selectedCircles.count > 0 && !CGPointEqualToPoint(_endPoint, CGPointZero)) {
		// Obtain circles
		IOPatternLockModel *from = [_selectedCircles lastObject];
		
		// Obtain points
		CGPoint centerPoint = CGPointCenterOfCircle(_circleSize, from);
		IOPointsModel *points = [IOPointsModel new];
		points.p1 = centerPoint;
		points.p2 = _endPoint;
			
		// Draw lines
		[self drawLinesToContext:context withPoints:points];
	}
}

- (void)drawLinesToContext:(CGContextRef)context withPoints:(IOPointsModel *)points {
	// Check points is null
	if (!points) {
		// Do nothing
		return;
	}
	
	// Create line path
	UIBezierPath *linePath =[UIBezierPath bezierPath];
	[linePath moveToPoint:points.p1];
	linePath.lineWidth = _lineWidth;
	[linePath addLineToPoint:points.p2];
	
	// Update colors
	CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
	CGContextSetFillColorWithColor(context, _lineColor.CGColor);
	[linePath stroke];
	[linePath fill];
}
	
#pragma mark - Actions

- (void)handlePan:(UIPanGestureRecognizer *)sender {
	// Obtain coordinates
	CGPoint gestureCoordinate = [sender locationInView:self];
	
	// Check sender state
	if (sender.state == UIGestureRecognizerStateBegan) {
		// Reset state
		[self deactivateAllGestures];
		
		// Find circle
		IOPatternLockModel *circlePattern = [self getCircleFromPoint:gestureCoordinate];
		if (circlePattern) {
			// Update gesture status
			circlePattern.isActive = YES;
			_startCirclePatternIndex = circlePattern.index;
			
			// Add pattern to start line
			[_selectedCircles addObject:[circlePattern copy]];
		}
	}
	else if (sender.state == UIGestureRecognizerStateChanged) {
		// Update end point
		_endPoint = gestureCoordinate;
		
		// Find circle
		IOPatternLockModel *circlePattern = [self getCircleFromPoint:gestureCoordinate];

		// Check drawing is start
		if (circlePattern && circlePattern.index != _startCirclePatternIndex) {
			// Activate circle pattern
			circlePattern.isActive = YES;
			_startCirclePatternIndex = circlePattern.index;
			
			// Add pattern to start line
			[_selectedCircles addObject:[circlePattern copy]];
		}
	}
	else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) {
		// Update gesture status
		_startCirclePatternIndex = -1;
		_endPoint = CGPointZero;
		
		// Handle pattern completed
		[self handlePatternCompleted];
	}
	
	// Redraw context
	[self setNeedsDisplay];
}

#pragma mark - Helper Methods

- (IOPatternLockModel *)getCircleFromPoint:(CGPoint)point {
	// Loop throught points
	for (IOPatternLockModel *pattern in _circlePoints) {
		// Check point in model
		if (point.x > pattern.x && point.y > pattern.y && point.x < pattern.x + _circleSize && point.y < pattern.y + _circleSize) {
			// Then return point
			return pattern;
		}
	}
	
	return nil;
}

- (void)deactivateAllGestures {
	// Reset lines
	_selectedCircles = [NSMutableArray new];
	
	// Loop throught circles
	for (IOPatternLockModel *pattern in _circlePoints) {
		pattern.isActive = NO;
	}
}

- (void)handlePatternCompleted {
	// Check delegate is null
	if (!self.delegate) {
		// Do nothing
		return;
	}
	
	// Pattern is success
	if (_minimumNumberOfSelections <= _selectedCircles.count) {
		// Create a selected circles array
		NSMutableArray<NSNumber *> *selectedCircleIndexes = [NSMutableArray new];
		
		// Loop throught selected circles
		for (IOPatternLockModel *patternLock in _selectedCircles) {
			// Add circle to selected
			[selectedCircleIndexes addObject:[NSNumber numberWithUnsignedInteger:patternLock.index]];
		}
		
		// Call delegate
		[self.delegate IOPatternLockView:self patternCompleted:selectedCircleIndexes];
	}
	else {
		// Create an error
		NSError *error = [NSError errorWithDomain:IOPatternLockErrorDomain code:0 userInfo:@{
																							 NSLocalizedDescriptionKey: @"Pattern is too short."
																							}];
		
		// Call delegate
		[self.delegate IOPatternLockView:self patternCompletedWithError:error];
	}
}

- (void)redraw {
	// Deactive
	[self deactivateAllGestures];
	
	// Redraw
	[self setNeedsDisplay];
}

#pragma mark - Setters

- (void)setColumn:(NSInteger)column {
	_column = column;
}

- (void)setRow:(NSInteger)row {
	_row = row;
}

- (void)setBorderWidth:(NSUInteger)borderWidth {
	_borderWidth = borderWidth;
}

- (void)setCircleSpace:(NSUInteger)circleSpace {
	_circleSpace = circleSpace;
}

- (void)setInnerCirclePadding:(NSUInteger)innerCirclePadding {
	_innerCirclePadding = innerCirclePadding;
}

- (void)setLineWidth:(NSUInteger)lineWidth {
	_lineWidth = lineWidth;
}

- (void)setActiveBorderColor:(UIColor *)activeBorderColor {
	_activeBorderColor = activeBorderColor;
}

- (void)setActiveInnerCircleColor:(UIColor *)activeInnerCircleColor {
	_activeInnerCircleColor = activeInnerCircleColor;
}

- (void)setBorderColor:(UIColor *)borderColor {
	_borderColor = borderColor;
}

- (void)setInnerCircleColor:(UIColor *)innerCircleColor {
	_innerCircleColor = innerCircleColor;
}

- (void)setLineColor:(UIColor *)lineColor {
	_lineColor = lineColor;
}

@end
