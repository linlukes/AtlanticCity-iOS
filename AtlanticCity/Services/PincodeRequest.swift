//
//  PincodeRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 20/05/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class PincodeRequest{
    
    static func sendInvite(message:String,phoneno:String,id:String,success: @escaping (PincodeBase?,Error?) -> ()) {
         guard let url = URL(string: Helpers.main_url+"api/v1/send_invite_messages") else {
             return
         }
         let params: Parameters = [
             "list_phone":phoneno,
             "message":message,
             "id":id
         ]
         AF.request(url, method: .post,parameters: params)
             .validate(statusCode: 200..<500)
             .responseObject{ (response: AFDataResponse<PincodeBase>) in
                 
                 switch response.result {
                 case let .success(value):
    print(value)
                     print("Pincode Validation Successful")
                     let swiftyJsonVar = value
                     success(swiftyJsonVar,nil)
                 case let .failure(error):
                     print(error)
                     success(nil,error)
                 }
         }
     }
    static func sendPin(message:String,phoneno:String,success: @escaping (PincodeBase?,Error?) -> ()) {
           guard let url = URL(string: Helpers.main_url+"api/v1/send_pincode") else {
               return
           }
           let params: Parameters = [
               "list_phone":phoneno,
               "message":message
           ]
           AF.request(url, method: .post,parameters: params, encoding: URLEncoding.default)
               .validate(statusCode: 200..<500)
               .responseObject{ (response: AFDataResponse<PincodeBase>) in
                   
                   switch response.result {
                   case let .success(value):
    print(value)
                       print("Pincode Validation Successful")
                       let swiftyJsonVar = value
                       success(swiftyJsonVar,nil)
                   case let .failure(error):
                       print(error)
                       success(nil,error)
                   }
           }
       }
}
