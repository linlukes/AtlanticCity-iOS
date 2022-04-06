//
//  SignupRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 27/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class SignupRequest{
    static func Signup(firstname:String,lastname:String,usermobile:String,email:String,password:String,id:String,device_id:String,success: @escaping (SignupBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/register") else {
            return
        }
        let params: Parameters = [
            "first_name":firstname,
            "last_name":lastname,
            "email": email,
            "phoneno": usermobile,
            "password" : password,
            "id":id,
            "device_id":device_id
        ]
        
        AF.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<SignupBase>) in
                
            switch response.result {
                case let .success(value):
    print(value)
                    print("Signup Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
}
