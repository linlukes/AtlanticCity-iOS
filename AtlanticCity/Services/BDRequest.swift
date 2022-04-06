//
//  BDRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 02/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class BDRequest{
    static func getBusinessDetail(user_id:String,auth_id:String,business_id:String,success: @escaping (BDBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/business-deals") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
        let params: Parameters = [
            "business_id":business_id
        ]
        AF.request(url, method: .post, parameters: params,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<BDBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("Business Detail Started Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
}
