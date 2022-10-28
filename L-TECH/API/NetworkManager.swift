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
}
