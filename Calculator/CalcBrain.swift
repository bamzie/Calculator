//
//  CalcBrain.swift
//  Calculator
//
//  Created by Brian Morales on 8/31/17.
//  Copyright © 2017 Bamzii. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    mutating func addUnaryOperation(named symbol: String,_ operation: @escaping (Double) -> Double){
        operations[symbol] = Operation.unary(operation)
    }
    
    private var accumaletor: Double?
    
    private enum Operation {
        case constant(Double)
        case unary((Double)-> Double)
        case binary((Double,Double) -> Double)
        case equals
        case decimal
    }
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi), //Double.pi,
        "e" : Operation.constant(M_E), //M_E,
        "√" : Operation.unary(sqrt), //sqrt,
        "cos" : Operation.unary(cos), //cos
        "±" : Operation.unary({ -$0 }),
        "×" : Operation.binary({ $0 * $1 }),
        "÷" : Operation.binary({$0 / $1}),
        "+" : Operation.binary({$0 + $1}),
        "-" : Operation.binary({$0 - $1}),
        "=" : Operation.equals,
        "." : Operation.decimal
    ]
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumaletor = value
            case .unary(let function):
                if accumaletor != nil {
                accumaletor = function(accumaletor!)
                }
            case .binary(let function):
                if accumaletor != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumaletor!)
                    accumaletor = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .decimal:
                break
            }
        }
        
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumaletor != nil {
            accumaletor = pendingBinaryOperation!.perform(with: accumaletor!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumaletor = operand
    }
    
    //Read only variable
    var result: Double? {
        get {
            return accumaletor
        }
    }
}
