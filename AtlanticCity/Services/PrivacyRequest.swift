//
//  PrivacyRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 20/05/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class PrivacyRequest{
    
    static func getPrivacy(success: @escaping (PrivacyBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/privacy_policy") else {
                return
            }
        AF.request(url, method: .get)
                .validate(statusCode: 200..<500)
                .responseObject{ (response: AFDataResponse<PrivacyBase>) in
                    
                    switch response.result {
                    case let .success(value):
    print(value)
                        print("Privacy Validation Successful")
                        let swiftyJsonVar = value
                        success(swiftyJsonVar,nil)
                    case let .failure(error):
                        print(error)
                        success(nil,error)
                    }
            }
        }
       
    
}
