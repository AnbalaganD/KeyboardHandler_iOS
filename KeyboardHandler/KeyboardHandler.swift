//
//  KeyboardHandler.swift
//  KeyboardHandler
//
//  Created by Anbu on 04/01/18.
//  Copyright © 2018 Anbu. All rights reserved.
//

import UIKit

class KeyboardHandler {
    
    private weak var activeTextInputView: UIView?
    private var keyboardUserInfo: Notification?
    private var isKeyboardPresent: Bool = false
    private var viewOriginalFrameCache: CGRect?
    
    static var shared = KeyboardHandler()
    
    private init() { }
    
    func enableKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow(notification:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTextInputFieldBeginEdit(notification:)), name: Notification.Name.UITextFieldTextDidBeginEditing, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTextInputFieldEndEdit(notification:)), name: Notification.Name.UITextFieldTextDidEndEditing, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTextInputFieldBeginEdit(notification:)), name: Notification.Name.UITextViewTextDidBeginEditing, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTextViewDidChange(notification:)), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onTextInputFieldEndEdit(notification:)), name: Notification.Name.UITextViewTextDidEndEditing, object: nil)
    }
    
    func disableKeyboardHandling() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidBeginEditing, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidEndEditing, object: nil)
    }
    
    @objc private func onKeyboardShow(notification: Notification) {        
        let keyboardFrame = notification.userInfo!["UIKeyboardFrameEndUserInfoKey"] as? CGRect
        isKeyboardPresent = true
        keyboardUserInfo = notification
        
        if let kf = keyboardFrame, let inputView = activeTextInputView {
            //get view position based on window not on immediate parent
            // to: nil - means calcute position based on window
            var inputViewOrigin = inputView.convert(CGPoint(x: 0, y: 0) , to: nil)
            
            //If active TextInputView is UITextView find the exact origin
            if let textView = activeTextInputView as? UITextView {
                if textView.isScrollEnabled {
                    inputViewOrigin.y += textView.contentOffset.y
                }
            }
            
            //Check whether UITextField / UITextView hide behind keyboard or not
            if kf.minY < inputViewOrigin.y + inputView.frame.height {
                guard let rootView = getTopViewController()?.view else {
                    return
                }
                //Calculte keyboard starting posiotion using 'kf.minY'
                //Calculate UITextField / UITextView starting posiotion using 'inputViewOrigin.y'
                //Calculate UITextField / UITextView height using 'inputView.frame.height'
                //Get View Already moved position using 'self.view.frame.minY'
                var movingDistance = (kf.minY - inputViewOrigin.y) - inputView.frame.height + rootView.frame.minY
                
                //If movingDistance greater than keyboard height reset the movingDistance equal to keyboard height
                if abs(movingDistance) > kf.height {
                    movingDistance = -kf.height
                }
                
                //Capture the view original frame before move
                if(viewOriginalFrameCache == nil) {
                    viewOriginalFrameCache = rootView.frame
                }
                
                //Finally move the top view to particular movingDistance
                rootView.frame = CGRect(x: rootView.frame.minX, y: movingDistance, width: rootView.frame.width, height: rootView.frame.height)
                rootView.layoutIfNeeded()
            }
        }
    }
    
    @objc private func onKeyboardHide(notification: Notification) {
        isKeyboardPresent = false
        keyboardUserInfo = nil
        
        //If Keyboard will hide reset the top view to original position
        guard let rootView = getTopViewController()?.view, let frame = viewOriginalFrameCache else {
            return
        }
        rootView.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: frame.height)
        rootView.layoutIfNeeded()
        viewOriginalFrameCache = nil
    }
    
    @objc private func onTextInputFieldBeginEdit(notification: Notification) {
        activeTextInputView = notification.object as? UIView
        if isKeyboardPresent {
            onKeyboardShow(notification: keyboardUserInfo!)
        }
    }
    
    @objc private func onTextInputFieldEndEdit(notification: Notification) {
        activeTextInputView = nil
    }
    
    @objc private func onTextViewDidChange(notification: Notification) {
        if isKeyboardPresent {
            onKeyboardShow(notification: keyboardUserInfo!)
        }
    }
    
    private func getTopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return getTopViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return getTopViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return getTopViewController(controller: presented)
        }
        return controller
    }
}
