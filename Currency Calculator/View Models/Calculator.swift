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
    private var firstOperandText: NSMutableString?
    private var secondOperandText: NSMutableString?
    
    // MARK: API
    var displayText: String {
        get {
            return evaluatedText()
        }
    }

    func processDigit(_ digit: String) {
        switch digit {
        case ".":
            guard let activeOperand = getActiveOperand() else {return}
            if !activeOperand.contains(digit) {
                activeOperand.append(digit)
            } else if activeOperand.length == 0 {
                activeOperand.append("0" + digit)
            }

            break
        case "+/-":
            performSignOperation()
            break

        default:
            guard let activeOperand = getActiveOperand() else {return}
            activeOperand.append(digit)
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
        guard let _ = activeOperation else {return firstNum as String}
        guard let secondNum = secondOperandText else {return firstNum as String}
        
        return secondNum as String
    }
    
    private func performClearOperation() {
        activeOperation = nil
        firstOperandText = nil
        secondOperandText = nil
    }
    
    private func performEqualOperation() {
        if let first = firstOperandText, let op = activeOperation, let second = secondOperandText {
            guard let result = calculate(firstOperand: first as String, secondOperand: second as String, operation: op) else {return}
            performClearOperation()
            firstOperandText = NSMutableString(string:result.stringValue)
        }
    }
    
    private func performMathOperation(op: String) {
        performEqualOperation()
        activeOperation = op
    }
    
    private func performSignOperation() {
        guard var activeOperand = getActiveOperand() else {return}
        if activeOperand.length > 0 , let num = Float(activeOperand as String) {
            activeOperand = NSMutableString(string: NSNumber(value: -num).stringValue)
        }
    }

    private func performPercentOperation() {
        guard var activeOperand = getActiveOperand() else {return}
        if activeOperand.length > 0, let num = Float(activeOperand as String) {
            activeOperand = NSMutableString(string:NSNumber(value: num/100.0).stringValue)
        }
    }

    private func calculate(firstOperand: String, secondOperand: String, operation: String) -> NSNumber? {
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
    
    private func getActiveOperand() -> NSMutableString? {
        if activeOperation == nil {
            if firstOperandText == nil {
                firstOperandText = NSMutableString()
            }
            return firstOperandText
        } else if secondOperandText == nil {
            secondOperandText = NSMutableString()
        }
        
        return secondOperandText
    }
}

protocol CalculatorDelegate: NSObjectProtocol {
    func calculatorDidUpdateDisplayText(sender: Calculator, displayText: String);
}
