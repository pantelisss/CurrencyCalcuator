//
//  Calculator.swift
//  Currency Calculator
//
//  Created by Pantelis Giazitsis on 04/02/2018.
//  Copyright © 2018 Pantelis Giazitsis. All rights reserved.
//

import UIKit

class Calculator: NSObject {
    weak var delegate: CalculatorDelegate?

    private var activeOperation: String?
    private var firstOperandText: String?
    private var secondOperandText: String?
    
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
                if firstOperandText != nil && !firstOperandText!.contains(digit) {
                    firstOperandText?.append(digit)
                } else if firstOperandText == nil {
                    firstOperandText = "0" + digit
                }
            } else {
                if secondOperandText != nil && secondOperandText!.contains(digit) {
                    secondOperandText?.append(digit)
                } else if secondOperandText == nil {
                    secondOperandText = "0" + digit
                }
            }

            break
        case "+/-":
            performSignOperation()
            break

        default:
            if activeOperation == nil {
                if let _ = firstOperandText {
                    firstOperandText?.append(digit)
                } else {
                    firstOperandText = digit
                }
            } else {
                if let _ = secondOperandText {
                    secondOperandText?.append(digit)
                } else {
                    secondOperandText = digit
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
        case "%":
            performPercentOperation()
            break
        case "C":
            performClearOperation()
            break
        default: break
            
        }
        
        delegate?.calculatorDidUpdateDisplayText(sender: self, displayText: displayText)
    }
    
    // MARK: Helpers
    
    private func evaluatedText() -> String {
        guard let firstNum = firstOperandText else {return "0"}
        guard let _ = activeOperation else {return firstNum}
        guard let secondNum = secondOperandText else {return firstNum}
        
        return secondNum
    }
    
    private func performClearOperation() {
        activeOperation = nil
        firstOperandText = nil
        secondOperandText = nil
    }
    
    private func performEqualOperation() {
        if let first = firstOperandText, let op = activeOperation, let second = secondOperandText {
            guard let result = calculate(firstOperand: first, secondOperand: second, operation: op) else {return}
            performClearOperation()
            firstOperandText = result.stringValue
        }
    }
    
    private func performMathOperation(op: String) {
        performEqualOperation()
        activeOperation = op
    }
    
    private func performSignOperation() {
        if activeOperation == nil {
            if let _ = firstOperandText, let num = Float(firstOperandText!) {
                firstOperandText = NSNumber(value: -num).stringValue
            }
        } else if let _ = secondOperandText , let num = Float(secondOperandText!) {
            secondOperandText = NSNumber(value: -num).stringValue
        }
    }

    private func performPercentOperation() {
        if activeOperation == nil {
            if let _ = firstOperandText, let num = Float(firstOperandText!) {
                firstOperandText = NSNumber(value: num/100.0).stringValue
            }
        } else if let _ = secondOperandText , let num = Float(secondOperandText!) {
            secondOperandText = NSNumber(value: num/100.0).stringValue
        }
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

protocol CalculatorDelegate: NSObjectProtocol {
    func calculatorDidUpdateDisplayText(sender: Calculator, displayText: String);
}
