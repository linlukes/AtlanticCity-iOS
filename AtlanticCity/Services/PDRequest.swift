//
//  PDRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 08/04/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class PDRequest{
    static func getPointsDetails(user_id:String,auth_id:String,success: @escaping (PDBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/get_points") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
        AF.request(url, method: .post,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<PDBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("getPointsDetail Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
}
