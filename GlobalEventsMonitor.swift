//
//  GlobalEventsMonitor.swift
//  Spaces
//
//  Created by Tyler Reardon on 7/30/17.
//  Copyright © 2017 Tyler Reardon. All rights reserved.
//

import Foundation
import Cocoa

public class GlobalEventMonitor {
    
    private var monitor: AnyObject?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> ()
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> ()) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        self.monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject
    }
    
    public func stop() {
        if let monitor = self.monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }
}
