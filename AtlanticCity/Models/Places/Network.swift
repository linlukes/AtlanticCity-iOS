//
//  Network.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 09/07/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Alamofire
import ObjectMapper
import GoogleMaps

class Network {

    class GoogleAPI {
        class Map {
            
            class var googleApiKey: String {
                return Helpers.shared_maps_key
            }

            class func autocomplete(request: String,current_loc:CLLocation,kilometers:Int,completion: @escaping ([String]?) -> () ) {
                let meters = kilometers * 100
                let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(request)&components=country:us&location=\(current_loc.coordinate.latitude),\(current_loc.coordinate.longitude)&radius=\(meters)&key=\(googleApiKey)"
                AF.request(url)
                    .responseJSON { response in
                        switch response.result {
                        case let .success(value):
    print(value)
                            if let json = value as? [String: Any] {
                                //print("JSON: \(json)")
                                let places = Array<GoogleAutocompleteJSONModel>(json: json["predictions"])
                                let autocomplete = places.compactMap{ $0.title}
                                completion(autocomplete)
                            }
                        case let .failure(error):
                            print(error)
                        }
                       
                }
                
            }
        }
    }
}
