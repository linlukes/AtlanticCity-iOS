//
//  Connectivity.swift
//  groceryapp
//
//  Created by Hamza Arif on 02/01/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity{
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
