//
//  LoginViewController.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 27.10.2022.
//

import UIKit
import AnyFormatKit

protocol AuthenticationDelegate: AnyObject {
    func authenticationDidComplete()
}

final class LoginViewController: ViewController {
    
    // MARK: - Properties

    weak var delegate: AuthenticationDelegate?

//    var mask = ""
    var mask: String? = ""
    var maskForKeychain: String? = ""
    var phoneNumber: String? = ""
    var password: String? = ""
    var maskCount = 0
    let phoneNumberInputController = TextFieldStartInputController()
    var phoneNumberFormatter = PlaceholderTextInputFormatter(textPattern: "")
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Вход в аккаунт"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Телефон"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    private let viewForPhoneNumberTF: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.borderColor = UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 1).cgColor
        view.layer.borderWidth = 1.5
        return view
    }()
    
    private let phoneNumberTextField: UITextField = {
        let tf = UITextField()
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(handleTouchTF), for: .touchDown)
        tf.addTarget(self, action: #selector(checkIsEnabledForLoginButton), for: .editingChanged)
        return tf
    }()
    
    private let cleanTextInPhoneNumberTextFieldButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "icon_close"), for: .normal)
        button.addTarget(self, action: #selector(setupCardNumberController), for: .touchUpInside)
        return button
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Пароль"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()

    private let viewForPasswordTF: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.borderColor = UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 1).cgColor
        view.layer.borderWidth = 1.5
        return view
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Введите пароль"
        tf.isSecureTextEntry = true
        tf.addTarget(self, action: #selector(handleTouchPasswordTF), for: .touchDown)
        tf.addTarget(self, action: #selector(checkIsEnabledForLoginButton), for: .editingChanged)
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.67), for: .normal)
        button.backgroundColor = UIColor(red: 0.725, green: 0.831, blue: 0.976, alpha: 1)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    
    // MARK: - Lifecircle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoader(true)
        configureUI()
        
        if phoneNumber != "" && phoneNumber != nil,
           mask != "" && mask != nil,
           password != "" && password != nil {
            maskCount = getCountFromString(mask: mask ?? "")
            phoneNumberFormatter = PlaceholderTextInputFormatter(textPattern: mask ?? "")
            setupCardNumberController()
            phoneNumberTextField.text = phoneNumber
            passwordTextField.text = password
            checkIsEnabledForLoginButton()
            self.showLoader(false)
        } else {
            NetworkManager.fetchPhoneMaskAF(url: "http://dev-exam.l-tech.ru/api/v1/phone_masks") { [self] mask in
                guard let phoneMask = mask.phoneMask else { return }
                self.mask = self.updatePhoneMask(mask: phoneMask)
                self.maskForKeychain = phoneMask
                self.maskCount = getCountFromString(mask: phoneMask)
                self.phoneNumberFormatter = PlaceholderTextInputFormatter(textPattern: self.mask ?? "")
                setupCardNumberController()
                self.showLoader(false)
            }
        }
    }
        
    // MARK: - Private func
    
    private func deleteSymbolsAndDoStrings(phone: String) -> String {
        let arrayPhone = Array(phone)
        var finalPhone = ""
        
        for i in 0...arrayPhone.count - 1 {
            if strToInt(input: String(arrayPhone[i])) {
                finalPhone.append(arrayPhone[i])
            }
        }
        return finalPhone
    }
    
    private func strToInt(input: String) -> Bool {
        return UInt(input) != nil
    }
    
    private func updatePhoneMask(mask: String) -> String {
        var arrayMask = Array(mask)
        var finalMask = ""
        
        for i in 0...arrayMask.count - 1 {
            if arrayMask[i].isLetter {
                arrayMask[i] = "#"
            }
            finalMask.append(arrayMask[i])
        }
        return finalMask
    }
    
    private func getCountFromString(mask: String) -> Int {
        let arrayMask = Array(mask)
        var maskCount = 0
        
        for i in 0...arrayMask.count - 1 {
            if strToInt(input: String(arrayMask[i])) || arrayMask[i].isLetter {
                maskCount += 1
            }
        }
        return maskCount
    }

    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white

        view.addSubview(iconImage)
        iconImage.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(56)
            maker.centerX.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(iconImage.snp.bottom).offset(32)
            maker.centerX.equalToSuperview()
        }
        
        view.addSubview(phoneNumberLabel)
        phoneNumberLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(24)
            maker.left.right.equalToSuperview().inset(16)
        }
        view.addSubview(viewForPhoneNumberTF)
        viewForPhoneNumberTF.snp.makeConstraints { maker in
            maker.top.equalTo(phoneNumberLabel.snp.bottom).offset(8)
            maker.height.equalTo(44)
            maker.left.right.equalToSuperview().inset(16)
        }
        view.addSubview(phoneNumberTextField)
        phoneNumberTextField.snp.makeConstraints { maker in
            maker.top.equalTo(viewForPhoneNumberTF.snp.top)
            maker.height.equalTo(viewForPhoneNumberTF.snp.height)
            maker.left.equalTo(viewForPhoneNumberTF.snp.left).inset(10)
            maker.right.equalTo(viewForPhoneNumberTF.snp.right)
        }
        
        view.addSubview(cleanTextInPhoneNumberTextFieldButton)
        cleanTextInPhoneNumberTextFieldButton.snp.makeConstraints { maker in
            maker.right.equalTo(phoneNumberTextField.snp.right).inset(10)
            maker.centerY.equalTo(phoneNumberTextField.snp.centerY)
        }
        
        view.addSubview(passwordLabel)
        passwordLabel.snp.makeConstraints { maker in
            maker.top.equalTo(phoneNumberTextField.snp.bottom).offset(24)
            maker.left.right.equalToSuperview().inset(16)
        }
        view.addSubview(viewForPasswordTF)
        viewForPasswordTF.snp.makeConstraints { maker in
            maker.top.equalTo(passwordLabel.snp.bottom).offset(8)
            maker.height.equalTo(44)
            maker.left.right.equalToSuperview().inset(16)
        }
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { maker in
            maker.top.equalTo(viewForPasswordTF.snp.top)
            maker.height.equalTo(viewForPasswordTF.snp.height)
            maker.left.equalTo(viewForPasswordTF.snp.left).inset(10)
            maker.right.equalTo(viewForPasswordTF.snp.right)
        }
        passwordTextField.enablePasswordToggle()
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { maker in
            let window = UIApplication.shared.windows.first
            let bottomPadding = window?.safeAreaInsets.bottom
            if bottomPadding != nil && bottomPadding != 0 {
                maker.bottom.equalToSuperview().inset(bottomPadding!)
            } else {
                maker.bottom.equalToSuperview().inset(16)
            }
            maker.left.right.equalToSuperview().inset(16)
            maker.height.equalTo(54)
        }
    }
    
    @objc private func setupCardNumberController() {
        phoneNumberInputController.formatter = phoneNumberFormatter
        phoneNumberTextField.delegate = phoneNumberInputController
        phoneNumberTextField.text = phoneNumberFormatter.format("")
    }
    
    @objc private func handleTouchTF(textField: UITextField) {
        viewForPhoneNumberTF.layer.borderColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1).cgColor
    }
    
    @objc private func handleTouchPasswordTF(textField: UITextField) {
        viewForPasswordTF.layer.borderColor = UIColor(red: 158/255, green: 158/255, blue: 158/255, alpha: 1).cgColor
    }

    @objc private func handleUnTouchTF() {
        viewForPhoneNumberTF.layer.borderColor = UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 1).cgColor
        viewForPasswordTF.layer.borderColor = UIColor(red: 0.957, green: 0.957, blue: 0.957, alpha: 1).cgColor
    }
    
    @objc private func handleLogin() {
        guard let phone = phoneNumberTextField.text,
              let password = passwordTextField.text,
              loginButton.isEnabled else { return }

        let numbers = deleteSymbolsAndDoStrings(phone: phone)
        let parameters: [String: Any] = [
            "phone" : numbers,
            "password" : password
        ]

        NetworkManager.loginTestAF(url: "http://dev-exam.l-tech.ru/api/v1/auth", parameters: parameters) { authSuccess, error  in
            if let error = error {
                self.showMessage(withTitle: "Ошибка", message: error)
                return
            }
            
            if let authSuccess = authSuccess?.success {
                if authSuccess {
                    DataManagerAccount.shared.phoneNumber = self.phoneNumberTextField.text
                    DataManagerAccount.shared.mask = self.maskForKeychain
                    DataManagerAccount.shared.password = self.passwordTextField.text
                    self.delegate?.authenticationDidComplete()
                } else {
                    self.showMessage(withTitle: "Ошибка", message: "Неправильный номер телефона или пароль")
                }
            }
        }
    }
    
    @objc private func checkIsEnabledForLoginButton() {
        if let phone = phoneNumberTextField.text,
           let password = passwordTextField.text,
           phone != "",
           password != "",
           maskCount == getCountFromString(mask: phone) {
            loginButton.setTitleColor(.white, for: .normal)
            loginButton.backgroundColor = UIColor(red: 0.09, green: 0.439, blue: 0.922, alpha: 1)
            loginButton.isEnabled = true
        } else {
            loginButton.setTitleColor(.white.withAlphaComponent(0.67), for: .normal)
            loginButton.backgroundColor = UIColor(red: 0.725, green: 0.831, blue: 0.976, alpha: 1)
            loginButton.isEnabled = false
        }
    }
    
    //MARK: - Keyboard
    
    @objc override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)

        if let keyboardSize =  self.keyboardSize {
            self.keyboardSize = keyboardSize
            
            loginButton.snp.makeConstraints { maker in
                let window = UIApplication.shared.windows.first
                let bottomPadding = window?.safeAreaInsets.bottom
                if bottomPadding != nil && bottomPadding != 0 {
                    maker.bottom.equalToSuperview().inset(keyboardSize.height + bottomPadding!)
                } else {
                    maker.bottom.equalToSuperview().inset(keyboardSize.height + 16)
                }
            }
            
            //KeyHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc override func keyboardWillHide(_ notification: Notification) {
        super.keyboardWillHide(notification)
        
        loginButton.snp.makeConstraints { maker in
            let window = UIApplication.shared.windows.first
            let bottomPadding = window?.safeAreaInsets.bottom
            if bottomPadding != nil && bottomPadding != 0 {
                maker.bottom.equalToSuperview().inset(bottomPadding!)
//                maker.bottom.equalTo(view.snp.bottom).inset(34)//bottomPadding!)
            } else {
                maker.bottom.equalToSuperview().inset(16)
//                maker.bottom.equalTo(view.snp.bottom).inset(16)
            }
        }

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNumberTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        handleUnTouchTF()
    }
}
