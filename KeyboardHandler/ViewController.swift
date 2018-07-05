//
//  ViewController.swift
//  KeyboardHandler
//
//  Created by Anbu on 04/01/18.
//  Copyright © 2018 Anbu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var hobbiesTextField: UITextField!
    @IBOutlet weak var skillTextField: UITextField!
    
    private var gradientLayer: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        hideKeyboardWhenTapArround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = view.bounds
    }
    
    private func initialSetup() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.colors = [UIColor(red: 62.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1.0).cgColor, UIColor(red: 95.0/255.0, green: 54.0/255.0, blue: 161.0/255.0, alpha: 1.0).cgColor]
        gradientLayer?.locations = [0.0, 1.0]
        gradientLayer?.frame = view.bounds
        view.layer.insertSublayer(gradientLayer!, at: 0)
        
        //Add left side padding in all UITextView
        userNameTextField.leftView = UIView(frame: CGRect(x:0 , y: 0, width: 5, height: userNameTextField.frame.height))
        userNameTextField.leftViewMode = .always
        
        emailTextField.leftView = UIView(frame: CGRect(x:0 , y: 0, width: 5, height: emailTextField.frame.height))
        emailTextField.leftViewMode = .always
        
        mobileNumberTextField.leftView = UIView(frame: CGRect(x:0 , y: 0, width: 5, height: mobileNumberTextField.frame.height))
        mobileNumberTextField.leftViewMode = .always
        
        hobbiesTextField.leftView = UIView(frame: CGRect(x:0 , y: 0, width: 5, height: hobbiesTextField.frame.height))
        hobbiesTextField.leftViewMode = .always
        
        skillTextField.leftView = UIView(frame: CGRect(x:0 , y: 0, width: 5, height: skillTextField.frame.height))
        skillTextField.leftViewMode = .always
        
        userNameTextField.delegate = self
        emailTextField.delegate = self
        mobileNumberTextField.delegate = self
        hobbiesTextField.delegate = self
        skillTextField.delegate = self
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            mobileNumberTextField.becomeFirstResponder()
        } else if textField == mobileNumberTextField {
            hobbiesTextField.becomeFirstResponder()
        } else if textField == hobbiesTextField {
            skillTextField.becomeFirstResponder()
        } else {
            skillTextField.resignFirstResponder()
        }
        return true
    }
}
