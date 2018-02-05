//
//  Extensions.swift
//  Currency Calculator
//
//  Created by Pantelis Giazitsis on 05/02/2018.
//  Copyright © 2018 Pantelis Giazitsis. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

extension UIButton {
    func performTapAnimation() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        }, completion: { finished in
            UIView.animate(withDuration: 0.1, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
    
    func selectOperationButton()  {
        self.isSelected = true
        self.backgroundColor = UIColor(named: "OperationsColorSelected")
    }
    
    func deSelectOperationButton()  {
        self.isSelected = false
        self.backgroundColor = UIColor(named: "OperationsColor")
    }
}

extension NSMutableString {
    func safeAppend(_ str: String, maxlength: Int) {
        if self.length >= maxlength {
            return
        }
        
        self.append(str)
    }
}
