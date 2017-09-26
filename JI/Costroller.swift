//
//  Costroller.swift
//  JI
//
//  Created by Jerry U. on 9/27/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class Costroller: NSViewController {
    
    @IBOutlet var screen: NSTextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        NotificationCenter.default.addObserver(self, selector: #selector(self.noteGetter(_:)), name: Notification.Name("hmm"), object: nil)
    }
    
    @objc func noteGetter(_ note: Notification) {
        self.screen.textStorage?.append(note.userInfo?["TXT"] as! NSAttributedString)
        self.screen.scrollRangeToVisible(NSRange(location: self.screen.string.count, length: 0))

    }
    
}
