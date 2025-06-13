// Copyright (c) 2022 Microsoft, Inc.
// Use of this source code is governed by the MIT license that can be
// found in the LICENSE file.

#include "shell/browser/ui/cocoa/electron_ns_panel.h"

@implementation ElectronNSPanel

@synthesize originalStyleMask;

- (id)initWithShell:(electron::NativeWindowMac*)shell
          styleMask:(NSUInteger)styleMask {
  if (self = [super initWithShell:shell styleMask:styleMask]) {
    originalStyleMask = styleMask;
    // Set window collection behavior to prevent activation
    // while still allowing interaction
    // NSWindowCollectionBehavior behavior = [self collectionBehavior];
    // behavior |= NSWindowCollectionBehaviorTransient;  // Makes window
    // non-activating behavior |= NSWindowCollectionBehaviorIgnoresCycle;  //
    // Excludes from window cycling behavior |=
    // NSWindowCollectionBehaviorMoveToActiveSpace;  // Allows showing on active
    // space [self setCollectionBehavior:behavior];

    // Allow becoming key window while preventing main window status
    // [self setCanBecomeKeyWindow:YES];
    // [self setCanBecomeMainWindow:NO];
    [self setPreventsActivation:YES];
    // Set window level to floating

    [self setLevel:NSFloatingWindowLevel];
  }
  return self;
}

@dynamic styleMask;

// Override to prevent activation
- (BOOL)canBecomeMainWindow {
  return NO;
}

// Allow key window status for input handling
- (BOOL)canBecomeKeyWindow {
  return YES;
}

// The Nonactivating mask is reserved for NSPanel,
// but we can use this workaround to add it at runtime
- (NSWindowStyleMask)styleMask {
  return originalStyleMask | NSWindowStyleMaskNonactivatingPanel;
}

- (void)setStyleMask:(NSWindowStyleMask)styleMask {
  originalStyleMask = styleMask;
  // Notify change of style mask.
  [super setStyleMask:styleMask];
}

- (void)setCollectionBehavior:(NSWindowCollectionBehavior)collectionBehavior {
  NSWindowCollectionBehavior panelBehavior =
      (NSWindowCollectionBehaviorMoveToActiveSpace |
       NSWindowCollectionBehaviorIgnoresCycle |
       NSWindowCollectionBehaviorTransient |
       NSWindowCollectionBehaviorFullScreenAuxiliary);
  [super setCollectionBehavior:panelBehavior];
}

- (void)setPreventsActivation:(BOOL)prevents {
  if ([self respondsToSelector:@selector(_setPreventsActivation:)]) {
    [self _setPreventsActivation:prevents];
  }
}

@end
