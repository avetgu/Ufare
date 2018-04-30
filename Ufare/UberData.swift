//
//  UberData.swift
//  Ufare
//
//  Created by Avery Gu on 4/29/18.
//  Copyright © 2018 Gu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UberData {
    
    var pickupLatitude: String
    var pickupLongitude: String
    var dropoffLatitude: String
    var dropoffLongitude: String
    
    let serverToken = "yFg5ORXjmt63vcYknhPlvzjfJvmjfxZkUENoTe_H"
    
    init(pickupLatitude: String, pickupLongitude: String, dropoffLatitude: String, dropoffLongitude: String) {
        self.pickupLatitude = pickupLatitude
        self.pickupLongitude = pickupLongitude
        self.dropoffLatitude = dropoffLatitude
        self.dropoffLongitude = dropoffLongitude
    }
    
    func getFareEstimates(completion: @escaping (UberFares) -> Void) {
        let urlString = "https://api.uber.com/v1.2/estimates/price?start_latitude=\(pickupLatitude)&start_longitude=\(pickupLongitude)&end_latitude=\(dropoffLatitude)&end_longitude=\(dropoffLongitude)"
        let url = URL(string: urlString)
        
        var uberFares = UberFares(uberPool: "", uberX: "", uberSUV: "", uberXL: "", uberBlack: "", uberWAV: "", uberTaxi: "")
        
        let headers: HTTPHeaders = [
            "Authorization": "Token yFg5ORXjmt63vcYknhPlvzjfJvmjfxZkUENoTe_H",
            "Accept-Language": "en_US",
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                for price in json["prices"].arrayValue {
                    if price["localized_display_name"].stringValue == "POOL" {
                        uberFares.uberPool = price["estimate"].stringValue
                    }
                    if price["localized_display_name"].stringValue == "uberX" {
                        uberFares.uberX = price["estimate"].stringValue
                    }
                    if price["localized_display_name"].stringValue == "uberXL" {
                        uberFares.uberXL = price["estimate"].stringValue
                    }
                    if price["localized_display_name"].stringValue == "UberBLACK" {
                        uberFares.uberBlack = price["estimate"].stringValue
                    }
                    if price["localized_display_name"].stringValue == "uberSUV" {
                        uberFares.uberSUV = price["estimate"].stringValue
                    }
                    if price["localized_display_name"].stringValue == "uberWAV" {
                        uberFares.uberWAV = price["estimate"].stringValue
                    }
                    if price["localized_display_name"].stringValue == "TAXI" {
                        uberFares.uberTaxi = price["estimate"].stringValue
                    }
                }
                print("uberPool estimate: \(uberFares.uberPool), uberX estimate: \(uberFares.uberX), uberXL estimate: \(uberFares.uberXL), uberBlack estimate: \(uberFares.uberBlack)")
            case .failure(let error):
                print(error)
            }
            completion(uberFares)
        }
    }
}

