//
//  PointsRequest.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 30/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class PointsRequest{
    static func addRegistrationPoints(authid:String,userid:String,success: @escaping (PointsBase?,Error?) -> ()) {
           guard let url = URL(string: Helpers.main_url+"api/v1/add-registration") else {
               return
           }
          let headers: HTTPHeaders = [
              "user-id":userid,
              "auth-id":authid
          ]
        AF.request(url, method: .post, headers: headers)
               .validate(statusCode: 200..<500)
               .responseObject{ (response: AFDataResponse<PointsBase>) in
                   
                   switch response.result {
                   case let .success(value):
    print(value)
                       print("Points Validation Successful")
                       let swiftyJsonVar = value
                       success(swiftyJsonVar,nil)
                   case let .failure(error):
                       print(error)
                       success(nil,error)
                   }
           }
       }
    static func addZipCodePoints(authid:String,userid:String,zipcode:String,success: @escaping (PointsBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/add-zipcode") else {
            return
        }
       let headers: HTTPHeaders = [
           "user-id":userid,
           "auth-id":authid
       ]
        let params:Parameters = [
            "zipcode":zipcode
        ]
     AF.request(url, method: .post,parameters: params, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<PointsBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("Zipcode Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
    static func addBirthdayPoints(authid:String,userid:String,dateofbirth:String,success: @escaping (PointsBase?,Error?) -> ()) {
        guard let url = URL(string: Helpers.main_url+"api/v1/date-of-birth") else {
            return
        }
       let headers: HTTPHeaders = [
           "user-id":userid,
           "auth-id":authid
       ]
        let params:Parameters = [
            "date_of_birth":dateofbirth
        ]
     AF.request(url, method: .post,parameters: params, encoding: URLEncoding.default, headers: headers)
            .validate(statusCode: 200..<500)
            .responseObject{ (response: AFDataResponse<PointsBase>) in
                
                switch response.result {
                case let .success(value):
    print(value)
                    print("Birthday Validation Successful")
                    let swiftyJsonVar = value
                    success(swiftyJsonVar,nil)
                case let .failure(error):
                    print(error)
                    success(nil,error)
                }
        }
    }
}
