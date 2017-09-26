//
//  AppDelegate.swift
//  JI
//
//  Created by Jerry U. on 5/17/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let window = NSApp.windows[0]
        
        let win = NSWindow.init(contentViewController: Costroller())
        window.addChildWindow(win, ordered:.below)
        win.title = "Cost/Error"
        
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

