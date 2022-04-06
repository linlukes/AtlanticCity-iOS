//
//  SigninRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 27/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class SigninRequest{
    static func Signin(email:String,password:String,success: @escaping (SigninBase?,Error?) -> ()) {
         guard let url = URL(string: Helpers.main_url+"api/v1/login") else {
             return
         }
         let params: Parameters = [
             "email": email,
             "password": password
         ]
         AF.request(url, method: .post, parameters: params)
             .validate(statusCode: 200..<500)
             .responseObject{ (response: AFDataResponse<SigninBase>) in
                 
                 switch response.result {
                 case let .success(value):
    print(value)
                     print("Signin Validation Successful")
                     let swiftyJsonVar = value
                     success(swiftyJsonVar,nil)
                 case let .failure(error):
                     print(error)
                     success(nil,error)
                 }
         }
     }
    static func SigninFacebook(facebookid:String,email:String,firstname:String,lastname:String,id:String,device_id:String,success: @escaping (SigninBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/login-with-facebook") else {
            return
        }
        let params: Parameters = [
            "facebook_id": facebookid,
            "email": email,
            "first_name": firstname,
            "last_name":lastname,
            "id":id,
            "device_id":device_id
        ]
        AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<SigninBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("Signin Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
    static func SigninGoogle(googleid:String,email:String,firstname:String,lastname:String,id:String,device_id:String,success: @escaping (SigninBase?,Error?) -> ()) {
          guard let url = URL(string: Helpers.main_url+"api/v1/login-with-google") else {
              return
          }
          let params: Parameters = [
              "google_id": googleid,
              "email": email,
              "first_name": firstname,
              "last_name":lastname,
              "id":id,
              "device_id":device_id
          ]
          AF.request(url, method: .post, parameters: params, encoding: URLEncoding.default)
              .validate(statusCode: 200..<500)
              .responseObject{ (response: AFDataResponse<SigninBase>) in
                  
                  switch response.result {
                  case let .success(value):
    print(value)
                      print("Signin Validation Successful")
                      let swiftyJsonVar = value
                      success(swiftyJsonVar,nil)
                  case let .failure(error):
                      print(error)
                      success(nil,error)
                  }
          }
      }
    static func setToken(user_id:String,auth_id:String,device_token:String,success: @escaping (PrivacyBase?,Error?) -> ()) {
       guard let url = URL(string: Helpers.main_url+"api/v1/update-device-token") else {
           return
       }
       let headers: HTTPHeaders = [
           "user-id":user_id,
           "auth-id":auth_id
       ]
        let params : Parameters = [
            "user-id":user_id,
            "device_token":device_token
        ]
       AF.request(url, method: .post,parameters: params, encoding: URLEncoding.default,headers: headers)
           .validate(statusCode: 200..<500)
           .responseObject{ (response: AFDataResponse<PrivacyBase>) in
               
               switch response.result {
               case let .success(value):
    print(value)
                   print("set token Validation Successful")
                   let swiftyJsonVar = value
                   success(swiftyJsonVar,nil)
               case let .failure(error):
                   print(error)
                   success(nil,error)
               }
       }
   }
}
