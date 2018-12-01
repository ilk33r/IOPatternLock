#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "IOPatternLock.h"
#import "IOPatternLockDelegate.h"
#import "IOPatternLockView.h"

FOUNDATION_EXPORT double IOPatternLockVersionNumber;
FOUNDATION_EXPORT const unsigned char IOPatternLockVersionString[];

