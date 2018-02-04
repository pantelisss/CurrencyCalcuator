//
//  Calculator.swift
//  Currency Calculator
//
//  Created by Pantelis Giazitsis on 04/02/2018.
//  Copyright © 2018 Pantelis Giazitsis. All rights reserved.
//

import UIKit

class Calculator: NSObject {
    weak var delegate: CalcuatorDelegate?

    private var activeOperation: String?
    private var firstNumberString: String?
    private var secondNumberString: String?
    
    // MARK: API
    var displayText: String {
        get {
            return evaluatedText()
        }
    }

    func processDigit(_ digit: String) {
        if activeOperation == nil {
            if let _ = firstNumberString {
                firstNumberString?.append(digit)
            } else {
                firstNumberString = digit
            }
        } else {
            if let _ = secondNumberString {
                secondNumberString?.append(digit)
            } else {
                secondNumberString = digit
            }
        }
        
        delegate?.calculatorDidUpdateDisplayText(sender: self, displayText: displayText)
    }
    
    func processOperation(_ operation: String) {
        
        switch operation {
        case "=":
            performEqualOperation()
            break
        case "+", "-", "*", "/":
            performMathOperation(op: operation)
            break
        case "%": break
            
        case "C":
            performClearOperation()
            break
        default: break
            
        }
        
        delegate?.calculatorDidUpdateDisplayText(sender: self, displayText: displayText)
    }
    
    // MARK: Helpers
    private func evaluatedText() -> String {
        guard let firstNum = firstNumberString else {return "0"}
        guard let _ = activeOperation else {return firstNum}
        guard let secondNum = secondNumberString else {return firstNum}
        
        return secondNum
    }
    
    private func performClearOperation() {
        activeOperation = nil
        firstNumberString = nil
        secondNumberString = nil
    }
    
    private func performEqualOperation() {
        if let first = firstNumberString, let op = activeOperation, let second = secondNumberString {
            let equation = first + op + second
            let expression = NSExpression(format: equation)
            let result = expression.expressionValue(with: nil, context: nil) as! NSNumber
            performClearOperation()
            firstNumberString = result.stringValue
        }
    }
    
    private func performMathOperation(op: String) {
        performEqualOperation()
        activeOperation = op
    }
}

protocol CalcuatorDelegate: NSObjectProtocol {
    func calculatorDidUpdateDisplayText(sender: Calculator, displayText: String);
}
