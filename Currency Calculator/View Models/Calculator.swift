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
    var displayText: String {
        get {
            return calcutationsString
        }
    }

    var activeOperation: String? {
        get {
            return nil
        }
    }

    private var calcutationsString: String = "" {
        didSet {
            delegate?.calculatorDidUpdateDisplayText(sender: self, displayText: displayText)
        }
    }
    
    // MARK: API
    func processDigit(_ digit: String) {
        calcutationsString.append(digit)
    }
    
    func processOperation(_ operation: String) {
        switch operation {
        case "=": break

        case "+": break
            
        case "-": break

        case "*": break

        case "/": break

        case "%": break
            
        case "C": break
            
        default: break
            
        }
    }
    
    // MARK: Helpers
    
    private func performClearOperation() {
        calcutationsString = ""
    }
}

protocol CalcuatorDelegate: NSObjectProtocol {
    func calculatorDidUpdateDisplayText(sender: Calculator, displayText: String);
}
