//
//  ChangePassRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 06/06/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class ChangePassRequest{
    static func changePass(user_id:String,auth_id:String,prevpass:String,newpass:String,success: @escaping (PassRecoveryBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/change-password") else {
            return
        }
        let params: Parameters = [
            "current_password":prevpass,
            "new_password":newpass
        ]
        let headers: HTTPHeaders = [
            "user-id":user_id,
            "auth-id":auth_id
        ]
        AF.request(url, method: .post, parameters: params,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<PassRecoveryBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("Change Password Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
}
