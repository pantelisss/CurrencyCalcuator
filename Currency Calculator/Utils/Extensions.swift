//
//  Extensions.swift
//  Currency Calculator
//
//  Created by Pantelis Giazitsis on 05/02/2018.
//  Copyright © 2018 Pantelis Giazitsis. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func performTapAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        }, completion: { finished in
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = CGAffineTransform.identity
            })
        })
    }
}
