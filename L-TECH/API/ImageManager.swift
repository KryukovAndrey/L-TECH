//
//  ImageManager.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 28.10.2022.
//

import Foundation
import Alamofire

class ImageManager {
    static func getImage(from url: String, completion: @escaping (Data) -> Void){
        AF.request(url)
            .validate()
            .responseData { (response) in
                switch response.result {
                case .success(let imageData):
                    completion(imageData)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
