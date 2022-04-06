//
//  PassRecoveryRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 15/05/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class PassRecoveryRequest{
    static func getPassRecovery(email:String,success: @escaping (PassRecoveryBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/forgot-password") else {
            return
        }
        let params: Parameters = [
            "email":email
        ]
        AF.request(url, method: .post,parameters: params)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<PassRecoveryBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("Password Recovery Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
}
