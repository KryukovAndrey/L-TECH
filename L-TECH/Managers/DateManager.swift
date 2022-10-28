//
//  DateManager.swift
//  L-TECH
//
//  Created by Andrey Kryukov on 28.10.2022.
//

import Foundation

final class DateManager {
    static func timeMessage(time: String?) -> String {
        guard let time = time else { return "" }
        let date = Date()
        let format = date.getFormattedDate(time: time)
        return format
    }
}
