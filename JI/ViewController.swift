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
    dynamic var absLab = "ABS Error"
    dynamic var useABS = true
    dynamic var smallredarr = true
    dynamic var arrFromABS = false
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
    dynamic var ty : String  = "ReLU"
    
    dynamic var selectedFormula : Double = 0.0
    
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
        }
    }
    
    @IBAction func ReLu(_ sender: Any) {
        DispatchQueue.main.async {
            self.selectedFormula = max(0.0, self.n2)
            self.result = max(0.0, (self.abs - self.selectedFormula))
            self.ty = #function
            self.choiceOfVisuals(ABS: true, arrowFromABS: false, smallArrow: true)
            self.absLab = "ABS Error"
        }
    }
    
    @IBAction func Sigmoid(_ sender: Any) {
        DispatchQueue.main.async {
            self.ty = #function
            self.choiceOfVisuals(ABS: false, arrowFromABS: false, smallArrow: false)
            
            self.selectedFormula = 1/(1 + exp(-self.n2))
            self.result = self.selectedFormula
        }
    }
    
    @IBAction func Linear(_ sender: Any) {
        self.ty = #function
        self.selectedFormula = self.linear(x: [self.n1], w: [self.n2w])
        self.result = self.abs - self.selectedFormula
        self.choiceOfVisuals(ABS: true, arrowFromABS: false, smallArrow: true)
        self.absLab = "ABS Error"
    }
    
    @IBAction func Binary(_ sender: Any) {
        self.ty = #function
        self.choiceOfVisuals(ABS: true, arrowFromABS: true, smallArrow: false)
        
        let bin = self.n1 * self.n2w
        self.n2 = bin
        self.absLab = "Threshold"
        self.selectedFormula = bin > self.abs ? 1 : 0
        self.result = self.selectedFormula
    }
    
    func choiceOfVisuals(ABS: Bool, arrowFromABS: Bool, smallArrow: Bool) {
        self.useABS = ABS
        self.smallredarr = smallArrow
        self.arrFromABS = arrowFromABS
    }

    func linear(x: [Double], w: [Double]) -> Double {
        var liner = 0.0
        for i in 0..<x.count {
            liner += x[i] * w[i]
        }
        return liner + self.n2b
    }

}

