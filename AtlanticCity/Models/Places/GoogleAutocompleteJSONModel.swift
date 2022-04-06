//
//  GoogleAutocompleteJSONModel.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 09/07/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import ObjectMapper

class GoogleAutocompleteJSONModel: Mappable, CustomStringConvertible {

    public fileprivate(set) var placeId: String?
    public fileprivate(set) var reference: String?
    public fileprivate(set) var title: String?

    required convenience init?(map: Map) {
        self.init()
    }

    func mapping(map: Map) {

        title                       <- map["description"]
        placeId                     <- map["place_id"]
        reference                   <- map["reference"]
    }

    var description: String {
        return "\(toJSON())"
    }
}
