//
//  EarnPointsRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 09/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class EarnPointsRequest{
    static func getEarnPoints(user_id:String,auth_id:String,success: @escaping (EarnPointsBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/get-birthday-zipcode-points") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
        AF.request(url, method: .post,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<EarnPointsBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("getEarnPoints Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
}
