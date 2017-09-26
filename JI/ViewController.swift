//
//  ViewController.swift
//  JI
//
//  Created by Jerry U. on 5/17/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var epochs: NSTextField!
    @IBOutlet var cEP: NSTextField!
    @objc dynamic var lr = 0.004
    @objc dynamic var Y = 0.74
    @objc dynamic var cep = "Current Epoch: 1"
    
    @IBOutlet var X1: NSTextField!
    @IBOutlet var X2: NSTextField!
    @IBOutlet var X3: NSTextField!
    @IBOutlet var L1Activation: NSPopUpButton!
    @IBOutlet var W1: NSTextField!
    @IBOutlet var b1: NSTextField!
    @IBOutlet var A1: NSTextField!
    
    @IBOutlet var L2Activation: NSPopUpButton!
    @IBOutlet var W2: NSTextField!
    @IBOutlet var b2: NSTextField!
    @IBOutlet var Z2: NSTextField!
    @IBOutlet var A2: NSTextField!
    
    @IBOutlet var L2Func: NSTextField!
    @IBOutlet var tresh: NSTextField!
    @IBOutlet var Y_pred: NSTextField!
    @IBOutlet var costScreen: NSTextView!
    
    var X : Matrix!
    var params: [String: Matrix]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let window = NSApp.windows[0]
        
            window.title = "NeuralNet Swift"
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
            
            X = Matrix([X1.doubleValue, X2.doubleValue, X3.doubleValue], rows: 3, columns: 1)
            params = initialize(n_x: 3, n_y: 1)
            W1.stringValue = params["W1"]!.description
            W2.stringValue = String(describing: params["W2"]!)
            b1.stringValue = String(describing: params["b1"]!)
            b2.stringValue = String(describing: params["b2"]!)
        
//        Train(nil)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
        
    }
    
    func f_prop(X: Matrix, params: [String: Matrix]) -> [String: Double]{
//        print(X)
        let Z1 = linear_fwd(W: params["W1"]!, A: X, b: params["b1"]!)
        
        let L1activation = L1Activation.selectedItem?.title.lowercased()
        
        let _A1: Double!
        let _gZ1: Double!
        switch L1activation! {
        case "relu":
            _A1 = relu(Z: Z1[0, 0])
            _gZ1 = reluPrime(Z: Z1[0, 0])
        case "sigmoid":
            _A1 = sigmoid(Z: Z1[0, 0])
            _gZ1 = sigmoidPrime(Z: Z1[0, 0])
        default:
            _A1 = tanh(Z1[0, 0])
            _gZ1 = tanhPrime(A: _A1)
        }
        
        let _Z2 = linear_fwd(W: params["W2"]!, A: Matrix.init([_A1], rows: 1, columns: 1), b: params["b2"]!)
        
        let L2activation = L2Activation.selectedItem?.title.lowercased()
        
        let _A2: Double!
        switch L2activation! {
        case "relu":
            _A2 = relu(Z: Z1[0, 0])
        case "sigmoid":
            _A2 = sigmoid(Z: Z1[0, 0])
        default:
            _A2 = tanh(Z1[0, 0])
        }
        
        self.A1.doubleValue = _A1
        self.A2.doubleValue = _A2
        self.Z2.doubleValue = _Z2[0,0]
//        print("Z1 = \(Z1)")
//        print("Z2 = \(_Z2)")
        
        return ["A1": _A1,"A2": _A2, "Z1":Z1[0,0], "gZ1": _gZ1, "Z2": _Z2[0,0]]
    }
    
    func cost(A2: Double, Y: Double) -> Double {
        return -((Y * log(A2)) + ((1-Y) * log(1-A2)))
    }
    
    func backProp(params: [String: Matrix], cache: [String: Double], X: Matrix, Y: Double) -> [String: Double] {
        
        let m = X.columns
        let W2 = params["W2"]!
        let _A2 = cache["A2"]!
        let _A1 = cache["A1"]!
        let _gZ1 = cache["gZ1"]!
        
        let dZ2 = _A2 - Y
        let dW2 = dZ2 * _A1
        let db2 = dZ2
        
        let dZ1 = (W2 * Matrix.init([dZ2], rows: 1, columns: 1)) * Matrix.init([_gZ1], rows: 1, columns: 1)
        let dW1 = Double((1/m)) * (X * dZ1).sumCols()
//        print("dW1 = \(dW1)")
        let db1 = dZ1[0,0]
        
        return ["dW2": dW2, "db2": db2, "dW1": dW1, "db1": db1]
    }
    
    func update_params(params: [String: Matrix], grads: [String: Double], learning_rate: Double) -> [String: Matrix] {

        let W1 = params["W1"]!
        let b1 = params["b1"]!
        let W2 = params["W2"]!
        let b2 = params["b2"]!

        for i in 0..<W1.columns {
            W1[0,i] = W1[0,i] - learning_rate * grads["dW1"]!
        }
        
        for i in 0..<b1.columns {
            b1[0,i] = b1[0,i] - learning_rate * grads["db1"]!
        }
        
        for i in 0..<W2.columns {
            W2[0,i] = W2[0,i] - learning_rate * grads["dW2"]!
        }
        
        for i in 0..<b2.columns {
            b2[0,i] = b2[0,i] - learning_rate * grads["db2"]!
        }

        return ["W1": W1, "b1": b1, "W2": W2, "b2": b2]
    }
    
    func predict(X: Matrix, params: [String: Matrix]) -> Double {
        let cache = f_prop(X: X, params: params)
        let y_pred = cache["A2"]
        
        return y_pred!
    }
    
    func linear_fwd(W: Matrix, A: Matrix, b: Matrix) -> Matrix {
        var Z = W * A
        Z = Z + b
        return Z
    }
    
    func initialize(n_x: Int, n_y: Int, n_h: Int = 1) -> [String: Matrix] {
        let W1 = Matrix(rows:n_h, columns:n_x, doIt: true)
        let b1 = Matrix([0.0], rows:n_h, columns:1)
        let W2 = Matrix(rows:n_y, columns:n_h)
        let b2 = Matrix([0.0], rows:n_y, columns:1)
        
        return ["W1": W1, "b1": b1, "W2": W2, "b2": b2]
    }
    
    func relu(Z: Double) -> Double {
        return max(0, Z)
    }
    
    func sigmoid(Z: Double) -> Double {
        return 1/(1+exp(-Z))
    }
    
    func reluPrime(Z: Double) -> Double {
        return Z > 0 ? 1 : 0
    }
    
    func sigmoidPrime(Z: Double) -> Double {
        return exp(-Z) / pow((1 + exp(-Z)), 2.0)
    }
    
    @IBAction func L2switch(_ sender: NSPopUpButton) {
        self.L2Func.stringValue = (sender.selectedItem?.title)!
    }
    func tanhPrime(A: Double) -> Double {
        return 1 - pow(A, 2.0)
    }
    
    @IBAction func Train(_ sender: Any?) {
        self.cEP.isHidden = false
        
        for i in 0..<epochs.intValue {
//            print("W1 = \(W1.stringValue)")
            let cache = f_prop(X: X, params: params)
            let cost_ = cost(A2: cache["A2"]!, Y: Y)
//            print("Cost[\(i+1)] = \(cost_)")
            let grads = backProp(params: params, cache: cache, X: X, Y: Y)
            params = update_params(params: params, grads: grads, learning_rate: lr)
            W1.stringValue = String(describing: params["W1"]!.round())
            W2.stringValue = String(describing: params["W2"]!.round())
            b1.stringValue = String(describing: params["b1"]!)
            b2.stringValue = String(describing: params["b2"]!)
            
            if i % 100 == 0 {
                self.cep = "Current epoch: \(i+1)"
                
                NotificationCenter.default.post(name: Notification.Name.init(rawValue: "hmm"), object: nil, userInfo: ["TXT":
                    NSAttributedString(string: String(format: "Cost[\(i+1)] = %.5f \t\t\t Error = %.5f\n", cost_, cache["A2"]! - Y))])
            }
        }
//        self.cEP.isHidden = true
        Y_pred.doubleValue = predict(X: X, params: params)
    }
    
}

