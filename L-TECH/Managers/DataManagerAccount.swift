//
//  DataManagerAccount.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 01.11.2022.
//

import Foundation
import KeychainAccess
import UIKit

class DataManagerAccount {
    static let shared = DataManagerAccount()
    private init() {}
    
    private let keychain = Keychain(service: "https://l-tech.ru/")
    
    var phoneNumber: String? {
        get {
            if let phoneNumber = keychain[string: "phoneNumber"] {
                return phoneNumber
            }
            return nil
        }
        set {
            keychain["phoneNumber"] = newValue
        }
    }
    
    var mask: String? {
        get {
            if let mask = keychain[string: "mask"] {
                return mask
            }
            return nil
        }
        set {
            keychain["mask"] = newValue
        }
    }
    
    var password: String? {
        get {
            if let password = keychain[string: "password"] {
                return password
            }
            return nil
        }
        set {
            keychain["password"] = newValue
        }
    }
    
    func logout() {
        phoneNumber = nil
        mask = nil
        password = nil
    }
}

