//
//  Created by Frank Gregor on 18.01.15.
//  Copyright (c) 2015 cocoa:naut. All rights reserved.
//

/*
 The MIT License (MIT)
 Copyright © 2014 Frank Gregor, <phranck@cocoanaut.com>
 http://cocoanaut.mit-license.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the â€œSoftwareâ€), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED â€œAS ISâ€, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

#import "CCNLaunchAtLoginItem.h"


@interface CCNLaunchAtLoginItem ()
@property (strong) NSString *bundlePath;
@property (strong) NSURL *bundleURL;
@end

@implementation CCNLaunchAtLoginItem

#pragma mark - Initialization

+ (instancetype)itemForBundle:(NSBundle *)bundle {
    return [[[self class] alloc] initWithBundle:bundle];
}

- (instancetype)initWithBundle:(NSBundle *)bundle {
    self = [super init];
    if (self) {
        self.bundlePath = [bundle bundlePath];
        self.bundleURL  = [NSURL fileURLWithPath:self.bundlePath];
    }
    return self;
}

#pragma mark - API

- (BOOL)isActive {
    BOOL isActiveLoginItem = NO;

    for (id item in [self loginItems]) {
        NSURL *itemURL = [self urlForLoginItem:(__bridge LSSharedFileListItemRef)item];
        if ([itemURL.path isEqualToString:self.bundleURL.path]) {
            isActiveLoginItem = YES;
            break;
        }
    }
    return isActiveLoginItem;
}

- (void)activate {
    if ([self isActive]) return;

    LSSharedFileListRef sharedSessionLoginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (sharedSessionLoginItems) {
        LSSharedFileListItemRef loginItem = LSSharedFileListInsertItemURL(sharedSessionLoginItems,
                                                                          kLSSharedFileListItemLast,
                                                                          NULL,
                                                                          NULL,
                                                                          (__bridge CFURLRef)self.bundleURL,
                                                                          NULL,
                                                                          NULL);
        CFRelease(sharedSessionLoginItems);
        if (loginItem){
            CFRelease(loginItem);
        }
    }
}

- (void)deActivate {
    if (![self isActive]) return;

    for (id item in [self loginItems]) {
        LSSharedFileListItemRef loginItem = (__bridge LSSharedFileListItemRef)item;
        NSURL *itemURL = [self urlForLoginItem:loginItem];
        if ([itemURL.path isEqualToString:self.bundleURL.path]) {
            LSSharedFileListRef sharedSessionLoginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
            LSSharedFileListItemRemove(sharedSessionLoginItems, loginItem);
            CFRelease(sharedSessionLoginItems);
            break;
        }
    }
}

#pragma mark - Private Helper

- (NSURL *)urlForLoginItem:(LSSharedFileListItemRef)itemRef {
    CFURLRef urlRef = LSSharedFileListItemCopyResolvedURL(itemRef, 0, NULL);
    return (__bridge_transfer NSURL *)urlRef;
}

- (NSArray *)loginItems {
    UInt32 seedValue;
    LSSharedFileListRef sharedFileListSessionLoginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    CFArrayRef loginItemsArrayRef = LSSharedFileListCopySnapshot(sharedFileListSessionLoginItems, &seedValue);
    CFRelease(sharedFileListSessionLoginItems);

    return (__bridge_transfer NSArray *)loginItemsArrayRef;
}

@end
