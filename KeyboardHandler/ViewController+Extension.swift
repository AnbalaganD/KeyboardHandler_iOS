//
//  ViewController+Extension.swift
//  KeyboardHandler
//
//  Created by Admin on 05/07/18.
//  Copyright © 2018 Anbu. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTapArround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
