//
//  Matrix.swift
//  JI
//
//  Created by Jerry U. on 9/27/17.
//  Copyright © 2017 Lyshnia Limited. All rights reserved.
//

import Cocoa

postfix operator ^
infix operator **

class Matrix {
    internal var data:Array<Double>
    var rows: Int
    var columns: Int
    init(_ data:Array<Double>, rows:Int, columns:Int) {
        self.data = data
        self.rows = rows
        self.columns = columns
    }
    init(rows:Int, columns:Int) {
        self.data = [Double](repeating: Double(arc4random_uniform(400)) * 0.01, count: rows*columns)
        self.rows = rows
        self.columns = columns
    }
    
    init(rows:Int, columns:Int, doIt yes: Bool) {
        var all = [Double]()
        for _ in 0..<columns {
            all.append(Double(arc4random_uniform(400)) * 0.01)
        }
        self.data = all
        self.rows = rows
        self.columns = columns
    }
    
    subscript(row: Int, col: Int) -> Double {
        get {
            return data[(row * columns) + col]
        }
        set {
            self.data[(row * columns) + col] = newValue
        }
    }
    
    func row(index:Int) -> [Double] {
        var r = [Double]()
        for col in 0..<columns {
            r.append(self[index,col])
        }
        return r
    }
    func col(index:Int) -> [Double] {
        var c = [Double]()
        for row in 0..<rows {
            c.append(self[row,index])
        }
        return c
    }
    
    func sumCols() -> Double {
        var c = 0.0
        for row in 0..<rows {
            c = c + (self[row,0])
        }
        return c
    }
    
    func round() -> Matrix {
        var c = [Double]()
        for row in 0..<columns {
            c.append(Darwin.round(1000 * self[0,row]) / 1000) // self[row,0]
        }
        return Matrix(c, rows: 1, columns: c.count)
    }
    
    static func +(left: Matrix, right: Matrix) -> Matrix {
        
        precondition(left.rows == right.rows && left.columns == right.columns)
        let m = Matrix(left.data, rows: left.rows, columns: left.columns)
        for row in 0..<left.rows {
            for col in 0..<left.columns {
                m[row,col] += right[row,col]
            }
        }
        return m
    }
    
    static postfix func ^(m:Matrix) -> Matrix {
        let t = Matrix(rows:m.columns, columns:m.rows)
        for row in 0..<m.rows {
            for col in 0..<m.columns {
                t[col,row] = m[row,col]
            }
        }
        return t
    }
    
    static func *(left:Matrix, right:Matrix) -> Matrix {
        
        var lcp = left.copy()
        var rcp = right.copy()
        
        if (lcp.rows == 1 && rcp.rows == 1) && (lcp.columns == rcp.columns) { // exception for single row matrices (inspired by numpy)
            rcp = rcp^
        }
        else if (lcp.columns == 1 && rcp.columns == 1) && (lcp.rows == rcp.rows) { // exception for single row matrices (inspired by numpy)
            lcp = lcp^
        }
        
        precondition(lcp.columns == rcp.rows, "Matrices cannot be multipied")
        
        let dot = Matrix(rows:lcp.rows, columns:rcp.columns)
        
        for i in 0..<lcp.rows {
            for j in 0..<rcp.columns {
                let a = lcp.row(index: i) ** rcp.col(index: j)
                dot[i,j] = a
            }
        }
        return dot
    }
    
    func copy(with zone: NSZone? = nil) -> Matrix {
        let cp = Matrix(self.data, rows:self.rows, columns:self.columns)
        return cp
    }
}

extension Matrix: CustomStringConvertible {
    var description: String {
        var dsc = ""
        for row in 0..<rows {
            for col in 0..<columns {
                let s = String(self[row,col])
                dsc += s + " "
            }
            dsc += "\n"
        }
        return dsc
    }
}

typealias Vector = [Double]

func **(left:Vector, right:Vector) -> Double {
    precondition(left.count == right.count)
    var d : Double = 0
    for i in 0..<left.count {
        d += left[i] * right[i]
    }
    return d
}
