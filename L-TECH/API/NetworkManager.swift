//
//  NetworkManager.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 28.10.2022.
//

import Alamofire

class NetworkManager {
    static func fetchDataAF(url: String, complition: @escaping ([Article]) -> Void){
        AF.request(url)
            .validate()
            .responseDecodable(of: [Article].self) { (data) in
                switch data.result {
                case .success(let articles): complition(articles)
                case .failure(let error): print(error.localizedDescription)
                }
            }
    }
    
    static func fetchPhoneMaskAF(url: String, complition: @escaping (PhoneMask) -> Void){
        AF.request(url)
            .validate()
            .responseDecodable(of: PhoneMask.self) { (data) in
                switch data.result {
                case .success(let phoneMask): complition(phoneMask)
                case .failure(let error): print(error.localizedDescription)
                }
            }
    }
    
    static func loginAF(url: String, complition: @escaping (AuthSuccess) -> Void){
        let url2 = "http://dev-exam.l-tech.ru/api/v1/auth"
        AF.request(url2)
            .validate()
            .responseDecodable(of: AuthSuccess.self) { (data) in
                switch data.result {
                case .success(let authSuccess): complition(authSuccess)
                case .failure(let error): print(error.localizedDescription)
                }
            }
    }
    
    static func loginTestAF(url: String, parameters: [String: Any], complition: @escaping (AuthSuccess?, String?) -> Void){
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: AuthSuccess.self) { (data) in
                switch data.result {
                case .success(let authSuccess): complition(authSuccess, nil)
                case .failure(let error): complition(nil, error.localizedDescription)//print(error.localizedDescription)
                }
            }
    }
}
