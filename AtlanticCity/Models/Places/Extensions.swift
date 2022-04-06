//
//  Extensions.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 09/07/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import ObjectMapper

extension Array where Element: Mappable {

    init(json: Any?) {
        self.init()

        var result = [Element]()
        if let array = json as? [[String: Any]] {
            for item in array {
                if let profile = Element(JSON: item) {
                    result.append(profile)
                }
            }
        }
        self = result
    }
}
