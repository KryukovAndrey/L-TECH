//
//  Article.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 28.10.2022.
//

import Foundation

struct Article: Codable {
    let id: String?
    let title: String?
    let text: String?
    let image: String?
    let sort: Int?
    let date: String?
}
