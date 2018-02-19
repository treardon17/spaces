//
//  AppDelegate.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/25/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Cocoa
import Silica

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem:NSStatusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength);
    var darkModeOn:Bool = true;
    var window:TROverlayWindow? = nil;

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        _ = TRWindowManager.sharedInstance
        // Start of Window Manager
//        let runningApps = TRWindowManager.sharedInstance.runningApps
//        for (_, app) in runningApps{
//            app.onMove = { element in
//                print("app moved: \(app.title)")
//                print(element)
//                let window = element as? SIWindow
//                print(window)
//                print(window?.frame())
//                if NSEvent.mouseLocation().x == 0{
//                    if let window = window, let screen = window.screen(){
//                        let width = screen.frame.width / 2
//                        let height = screen.frame.height
//                        window.setFrame(CGRect(x: 0, y: 0, width: width, height: height))
//                    }
//                }
//            }
//            
//            app.onApplicationActivated = { element in
//                print("app activated: \(app.title)")
//            }
//            
//            app.onCreate = { element in
//                print("app created: \(app.title)")
//            }
//            
//            app.onFocusChanged = { element in
//                print("focus change: \(app.title)")
//            }
//            
//            app.onMiniaturized = { element in
//                print("app miniaturized: \(app.title)")
//            }
//            
//            app.onDeminiaturized = { element in
//                print("app deminiaturized: \(app.title)")
//            }
//        }
        
//        // Show a mockup window
//        let frame = NSScreen.main()?.frame
//        if let frame = frame{
//            self.window = TROverlayWindow(contentRect: NSRect(x: 0, y: 0, width: 0, height: frame.size.height))
//            self.window?.show()
//            
//            let rect = NSRect(x: 0, y: 0, width: frame.size.width / 2, height: frame.size.height)
//            self.window?.setDimensions(rect, animated: true)
//        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

