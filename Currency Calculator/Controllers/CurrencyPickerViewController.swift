//
//  CurrencyPickerViewController.swift
//  Currency Calculator
//
//  Created by Pantelis Giazitsis on 04/02/2018.
//  Copyright © 2018 Pantelis Giazitsis. All rights reserved.
//

import UIKit

class CurrencyPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var currencies: [String] = []
    var completionBlock: ((_ selectedCurrency: String) -> Void)?
    var selectedCurrency: String? {
        didSet {
            guard let selected = selectedCurrency else {return}
            guard let index = currencies.index(of: selected) else {return}
            _ = view    // Force load view in case isn't loaded yet
            pickerView.reloadAllComponents()
            if pickerView.numberOfRows(inComponent: 0) > index {
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        completionBlock?(currencies[pickerView.selectedRow(inComponent: 0)])
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
 
    // MARK: UIPickerViewDelegate, UIPickerViewDataSource
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
}
