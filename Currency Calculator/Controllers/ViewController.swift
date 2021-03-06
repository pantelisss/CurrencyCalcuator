//
//  ViewController.swift
//  Currency Calculator
//
//  Created by Pantelis Giazitsis on 03/02/2018.
//  Copyright © 2018 Pantelis Giazitsis. All rights reserved.
//

import UIKit
import MBProgressHUD

fileprivate struct Constants {
    static let currencyButtonErrorText = "..."
}

class ViewController: UIViewController, CalculatorDelegate {

    @IBOutlet var digitButtons: [UIButton]!
    @IBOutlet var operationButtons: [UIButton]!
    @IBOutlet weak var equalButton: UIButton!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var primaryCurrencyButton: UIButton!
    @IBOutlet weak var secondaryLabel: UILabel!
    @IBOutlet weak var secondaryCurrencyButton: UIButton!
    @IBOutlet weak var errorView: UIView!
    
    private let calculator = Calculator()
    private let animator = ActionSheetAnimator()
    private var exchange: Exchange?
    private var selectedCurrency: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calculator.delegate = self
        setupUI()
        refreshExchange(base: nil)
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
        
        // Numpad Section
        for btn in digitButtons {
            btn.layer.cornerRadius = btn.frame.size.width / 2.0
            btn.layer.shadowColor = UIColor.black.cgColor
            btn.layer.shadowOpacity = 0.3
            btn.layer.shadowRadius = 3.0
        }
        
        for btn in operationButtons {
            btn.layer.cornerRadius = btn.frame.size.width / 2.0
            btn.layer.shadowColor = UIColor.black.cgColor
            btn.layer.shadowOpacity = 0.3
            btn.layer.shadowRadius = 3.0
        }
        
        equalButton.layer.cornerRadius = equalButton.frame.size.width / 2.0
        equalButton.layer.shadowColor = UIColor.black.cgColor
        equalButton.layer.shadowOpacity = 0.3
        equalButton.layer.shadowRadius = 3.0

        // Currency Section
        primaryLabel.adjustsFontSizeToFitWidth = true
        secondaryLabel.adjustsFontSizeToFitWidth = true
        updateCurrencySection()
        setErrorView(visible: false, animated: false)
    }
    
    // MARK: Controller Logic
    
    func refreshExchange(base: String?) {
        setErrorView(visible: false, animated: true)
        MBProgressHUD.showAdded(to: view, animated: true)
        _ = Client.sharedInstance.getExchange(base: base) { [unowned self] (exchange, err) in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if err != nil {
                self.setErrorView(visible: true, animated: true)
                
                return
            }
            
            self.exchange = exchange
            if self.selectedCurrency == nil {
              self.selectedCurrency = exchange?.rates.keys.first
            }
            
            self.updateCurrencySection()
        }
    }
    
    func updateCurrencySection() {
        if let ex = exchange, let selected = selectedCurrency {
            primaryCurrencyButton.setTitle(ex.base, for: .normal)
            secondaryCurrencyButton.setTitle(selected, for: .normal)
            
            if let amount = Float(calculator.displayText) {
                let price = ex.getPrice(currency: selected, amount: amount)
                secondaryLabel.text = String(price)
            } else {
                secondaryLabel.text = "0"
            }
        } else {
            secondaryLabel.text = "0"
            primaryCurrencyButton.setTitle(Constants.currencyButtonErrorText, for: .normal)
            secondaryCurrencyButton.setTitle(Constants.currencyButtonErrorText, for: .normal)
        }
        
        primaryLabel.text = calculator.displayText
    }
    
    func updateNumPadState() {
        for btn in operationButtons {
            if calculator.activeOperation == btn.title(for: .normal) {
                btn.selectOperationButton()
            } else {
                btn.deSelectOperationButton()
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func digitButtonTapped(_ sender: UIButton) {
        sender.performTapAnimation()
        
        guard let title = sender.title(for: .normal) else {
            return
        }
        
        calculator.processDigit(title)
    }
    
    @IBAction func operationButtonTapped(_ sender: UIButton) {
        sender.performTapAnimation()
        
        guard let title = sender.title(for: .normal) else {
            return
        }
        
        calculator.processOperation(title)
    }
    
    @IBAction func primaryCurrencyButtonTapped(_ sender: Any) {
        guard let ex = exchange else {return}
        presentCurrencyPicker(selectedCurrency: ex.base) { [weak self] (newlySelectedCurr) in
            self?.refreshExchange(base: newlySelectedCurr)
        }
    }

    @IBAction func secondaryCurrencyButtonTapped(_ sender: Any) {
        presentCurrencyPicker(selectedCurrency: selectedCurrency) { [weak self] (newlySelectedCurr) in
            self?.selectedCurrency = newlySelectedCurr
            self?.updateCurrencySection()
        }
    }
    
    @IBAction func errorLabelTapped(_ sender: Any) {
        refreshExchange(base: nil)
    }
    
    // MARK: Helpers
    
    func presentCurrencyPicker(selectedCurrency: String?, completion: @escaping (_ selectedCurrency: String) -> Void) {
        guard let ex = exchange else {return}
        var availableCurrencies = [ex.base]
        availableCurrencies.append(contentsOf: Array(ex.rates.keys))
        availableCurrencies.sort()
        
        let currencyPickerVC = CurrencyPickerViewController(nibName: String(describing: CurrencyPickerViewController.self), bundle: nil)
        currencyPickerVC.currencies = availableCurrencies
        currencyPickerVC.completionBlock = completion
        currencyPickerVC.selectedCurrency = selectedCurrency
        currencyPickerVC.transitioningDelegate = animator
        currencyPickerVC.modalPresentationStyle = .custom
        present(currencyPickerVC, animated: true, completion: nil)
    }
    
    func setErrorView(visible: Bool, animated: Bool) {
        let alpha: CGFloat = visible ? 1.0 : 0.0
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: {
                self.errorView.alpha = alpha
            }, completion: { (finished) in
                
            })
        } else {
            errorView.alpha = alpha
        }
    }
    
    // MARK: CalculatorDelegate
    
    func calculatorDidUpdateDisplayText(sender: Calculator, displayText: String) {
        updateCurrencySection()
        updateNumPadState()
    }
}

