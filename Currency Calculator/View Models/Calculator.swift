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
        switch digit {
        case ".":
            if activeOperation == nil {
                if firstNumberString != nil && !firstNumberString!.contains(digit) {
                    firstNumberString?.append(digit)
                } else if firstNumberString == nil {
                    firstNumberString = "0" + digit
                }
            } else {
                if secondNumberString != nil && secondNumberString!.contains(digit) {
                    secondNumberString?.append(digit)
                } else if secondNumberString == nil {
                    secondNumberString = "0" + digit
                }
            }

            break
        case "+/-":
            break

        default:
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
            break
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
            guard let result = calculate(firstOperand: first, secondOperand: second, operation: op) else {return}
            performClearOperation()
            firstNumberString = result.stringValue
        }
    }
    
    private func performMathOperation(op: String) {
        performEqualOperation()
        activeOperation = op
    }
    
    func calculate(firstOperand: String, secondOperand: String, operation: String) -> NSNumber? {
        guard let first = Float(firstOperand) else {return nil}
        guard let second = Float(secondOperand)  else {return nil}
        
        switch operation {
        case "+":
            return NSNumber(value: first + second)
        case "-":
            return NSNumber(value: first - second)
        case "*":
            return NSNumber(value: first * second)
        case "/":
            return NSNumber(value: first / second)
        default:
            return NSNumber(value: 0)
        }
    }
}

protocol CalcuatorDelegate: NSObjectProtocol {
    func calculatorDidUpdateDisplayText(sender: Calculator, displayText: String);
}
