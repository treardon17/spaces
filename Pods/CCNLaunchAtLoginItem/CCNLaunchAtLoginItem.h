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

@interface CCNLaunchAtLoginItem : NSObject

/**
 Creates and returns an instance of `CCNLaunchAtLoginItem` using the given application bundle.

 @param bundle An application bundle to create the LoginItem for.

 @return An instance of `CCNLaunchAtLoginItem`.
 */
+ (instancetype)itemForBundle:(NSBundle *)bundle;

/**
 Returns a boolean value that indicates whether the given application bundle has an active LoginItem.

 @return `YES` if the application bundle has an active LoginItem otherwise `NO`.
 */
- (BOOL)isActive;

/**
 Installs a LoginItem for the given application bundle. The application will be launched automatically on login.
 */
- (void)activate;

/**
 Removes the LoginItem for the given application bundle. The application will no longer be launched on login.
 */
- (void)deActivate;

@end
