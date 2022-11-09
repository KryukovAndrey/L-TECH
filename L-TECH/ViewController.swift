//
//  ViewController.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 27.10.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addKeyboardEventsListeners()
    }

    /// Keyboard size
    var keyboardSize: CGRect?
    
    fileprivate func addKeyboardEventsListeners() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func removeKeyboardEventListeners() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        self.removeKeyboardEventListeners()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let userInfo = (notification as NSNotification).userInfo {
            if let keyboardSize =  (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.keyboardSize = keyboardSize
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
    }
}

