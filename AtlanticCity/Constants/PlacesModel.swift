//
//  PlacesModel.swift
//  localcars
//
//  Created by Hamza Arif on 23/08/2019.
//  Copyright © 2019 hixol. All rights reserved.
//

import Foundation
import GoogleMaps

class PlacesModel{
    
    var placename : String?
    var placeaddress : String?
    var cordinates : CLLocationCoordinate2D?
    
    init(placen:String,placea:String,cordinates:CLLocationCoordinate2D) {
        self.placename = placen
        self.placeaddress = placea
        self.cordinates = cordinates
    }
    
}
