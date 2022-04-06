//
//  ReferralRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 06/07/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class ReferralRequest{
    static func getReferral(id:String,success: @escaping (ReferralBase?,Error?) -> ()) {
         guard let url = URL(string: Helpers.main_url+"api/v1/referral_users/"+id) else {
             return
         }
        
        AF.request(url, method: .get)
             .validate(statusCode: 200..<500)
             .responseObject{ (response: AFDataResponse<ReferralBase>) in
                 
                 switch response.result {
                 case let .success(value):
    print(value)
                     print("Referral Validation Successful")
                     let swiftyJsonVar = value
                     success(swiftyJsonVar,nil)
                 case let .failure(error):
                     print(error)
                     success(nil,error)
                 }
         }
     }
}
