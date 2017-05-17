//
//  ViewController.swift
//  JI
//
//  Created by Jerry U. on 5/17/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    dynamic var abs = 1.0
    dynamic var inp = -0.5 {
        didSet {
            N1()
            N2()
        }
    }
    dynamic var n1w = 1.0 {
        didSet {
            N1()
        }
    }
    dynamic var n1b = 2.0 {
        didSet {
            N1()
        }
    }
    dynamic var n2w = 1.3 {
        didSet {
            N2()
        }
    }
    dynamic var n2b = -1.0 {
        didSet {
            N2()
        }
    }
    
    dynamic var result : Double = 1.0
    dynamic var n1 : Double  = 0.0
    dynamic var n2 : Double = 0.0
    
    dynamic var relu : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let window = NSApp.windows[0]
        window.title = "NeuralNet Swift"
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.styleMask.insert(.fullSizeContentView)
        
        self.N1()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func N1() {
        DispatchQueue.main.async {
            self.n1 = (self.inp * self.n1w) + self.n1b
            self.N2()
        }
    }

    func N2() {
        DispatchQueue.main.async {
            self.n2 = (self.n1 * self.n2w) + self.n2b
            
            self.ReLu()
        }
    }
    
    func ReLu() {
        DispatchQueue.main.async {
            self.relu = max(0.0, self.n2)
            self.result = self.abs - self.relu
        }
    }


}

