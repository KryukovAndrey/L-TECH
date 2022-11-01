//
//  Extentions.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 28.10.2022.
//

import Foundation
import UIKit
import JGProgressHUD

extension UIViewController {
    static let hud = JGProgressHUD(style: .dark)
    
    func showLoader(_ show: Bool) {
        view.endEditing(true)
        
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
    
    func showMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension Date {
    func getFormattedDate(time: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMMM, HH:mm"
        dateFormatterPrint.locale = Locale.current

        let date: Date? = dateFormatterGet.date(from: time)
        return dateFormatterPrint.string(from: date!);
    }
}

extension UITextField {
    func setPasswordToggleImage(_ button: UIButton) {
        if (isSecureTextEntry) {
            button.setImage(UIImage(named: "icon_eye_close"), for: .normal)
        } else {
            button.setImage(UIImage(named: "icon_eye_open"), for: .normal)
        }
    }
    
    func enablePasswordToggle() {
        let button = UIButton(type: .custom)
        setPasswordToggleImage(button)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        self.rightView = button
        self.rightViewMode = .always
    }
    
    @objc func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
        
//    func addIconCloseInTextField() {
//        let button = UIButton(type: .custom)
//        button.setImage(UIImage(named: "icon_close"), for: .normal)
//        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
//        button.frame = CGRect(x: CGFloat(self.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
////        button.addTarget(self, action: #selector(self.deleteTextInTextField), for: .touchUpInside)
//        self.rightView = button
//        self.rightViewMode = .always
//    }

//    @objc func deleteTextInTextField(_ sender: Any) {
//        weak var updateTFText: TextFieldCleanTextDelegate?
//        updateTFText?.updateForm()
//    }
}

//protocol TextFieldCleanTextDelegate {
//    func updateForm()
//}
//
//extension UITextField
