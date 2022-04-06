//
//  ProfileRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 18/05/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class ProfileRequest{
    static func getProfile(userid:String,authid:String,success: @escaping (ProfileBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/get-profile") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":userid,
            "auth-id":authid
        ]
        AF.request(url, method: .post,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<ProfileBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("Get Profile Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
    static func updateProfile(userid:String,authid:String,firstname:String,lastname:String,address:String,email:String,phone:String,success: @escaping (ProfileBase?,Error?) -> ()) {
           guard let url = URL(string: Helpers.main_url+"api/v1/update-profile") else {
               return
           }
           let headers: HTTPHeaders = [
               "user-id":userid,
               "auth-id":authid
           ]
            let params : Parameters = [
                "email":email,
                "address":address,
                "phoneno":phone,
                "first_name":firstname,
                "last_name":lastname
            ]
           AF.request(url, method: .post,parameters: params,encoding: URLEncoding.default,headers: headers)
               .validate(statusCode: 200..<500)
               .responseObject{ (response: AFDataResponse<ProfileBase>) in
                   
                   switch response.result {
                   case let .success(value):
    print(value)
                       print("Update Profile Validation Successful")
                       let swiftyJsonVar = value
                       success(swiftyJsonVar,nil)
                   case let .failure(error):
                       print(error)
                       success(nil,error)
                   }
           }
       }
    static func addGuru(userid:String,authid:String,firstname:String,lastname:String,address:String,email:String,phone:String,success: @escaping (ProfileBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/add_guru_prize_winner_users") else {
            return
        }
        let headers: HTTPHeaders = [
            "user-id":userid,
            "auth-id":authid
        ]
         let params : Parameters = [
             "email":email,
             "address":address,
             "phoneno":phone,
             "first_name":firstname,
             "last_name":lastname
         ]
        AF.request(url, method: .post,parameters: params,encoding: URLEncoding.default,headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<ProfileBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("Add Guru Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
}
