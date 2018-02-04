//
//  ViewController.swift
//  Currency Calculator
//
//  Created by Pantelis Giazitsis on 03/02/2018.
//  Copyright © 2018 Pantelis Giazitsis. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CalculatorDelegate {

    @IBOutlet var digitButtons: [UIButton]!
    @IBOutlet var operationButtons: [UIButton]!
    @IBOutlet weak var primaryLabel: UILabel!
    
    private let calculator = Calculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calculator.delegate = self
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UI Setup
    
    func setupUI() {
        // Force layout operation because corner
        // radius depends on buttons size
        view.layoutIfNeeded()
        
        for btn in digitButtons {
            btn.layer.cornerRadius = btn.frame.size.width / 2.0
        }
        
        for btn in operationButtons {
            btn.layer.cornerRadius = btn.frame.size.width / 2.0
        }
        
        primaryLabel.text = calculator.displayText
    }
    
    // MARK: Actions
    
    @IBAction func digitButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else {
            return
        }
        
        calculator.processDigit(title)
    }
    
    @IBAction func operationButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else {
            return
        }
        
        calculator.processOperation(title)
    }
    
    // MARK: CalculatorDelegate
    
    func calculatorDidUpdateDisplayText(sender: Calculator, displayText: String) {
        primaryLabel.text = displayText
    }
}

