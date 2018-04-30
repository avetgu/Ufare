//
//  LyftData.swift
//  Ufare
//
//  Created by Avery Gu on 4/29/18.
//  Copyright © 2018 Gu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LyftData {
    
    var pickupLatitude: String
    var pickupLongitude: String
    var dropoffLatitude: String
    var dropoffLongitude: String
    var accessToken = ""
    
    let clientID = "DMGHwfiwPhyO"
    let clientSecret  = "vojjerCAMZRUnpYTw16xwMJfnkx3k7zQ"
    
    init(pickupLatitude: String, pickupLongitude: String, dropoffLatitude: String, dropoffLongitude: String) {
        self.pickupLatitude = pickupLatitude
        self.pickupLongitude = pickupLongitude
        self.dropoffLatitude = dropoffLatitude
        self.dropoffLongitude = dropoffLongitude
        
        getAccessToken()
    }
    
    func getAccessToken() {
        let urlString = "https://api.lyft.com/oauth/token"
        let url = URL(string: urlString)!
        let parameters: [String: Any] = [
            "grant_type": "client_credentials",
            "scope": "public"
        ]
        let header: HTTPHeaders = ["Content-Type" : "application/json"]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).authenticate(user: clientID, password: clientSecret).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.accessToken = json["access_token"].stringValue
                print(self.accessToken)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getFareEstimates(completion: @escaping (LyftFares) -> Void) {
        
//        curl --include -X GET -H 'Authorization: bearer <access_token>' \
//        'https://api.lyft.com/v1/cost?start_lat=37.7763&start_lng=-122.3918&end_lat=37.7972&end_lng=-122.4533'
        
        var lyftFares = LyftFares(lyftLine: "", lyft: "", lyftPlus: "", lyftPremier: "", lyftLux: "", lyftLuxSUV: "")
        
        let urlString = "https://api.lyft.com/v1/cost?start_lat=\(pickupLatitude)&start_lng=\(pickupLongitude)&end_lat=\(dropoffLatitude)&end_lng=\(dropoffLongitude)"
        let url = URL(string: urlString)!
        let headers: HTTPHeaders = ["Authorization" : "bearer \(accessToken)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("Printing fare estimates from lyft api")
                print(json)
                for ride in json["cost_estimates"].arrayValue {
                    if ride["display_name"].stringValue == "Lyft Line" {
                        print("here!!!")
                        lyftFares.lyftLine = "$" + String(ride["estimated_cost_cents_max"].doubleValue / 100.0)
                    }
                    if ride["display_name"].stringValue == "Lyft" {
                        lyftFares.lyft = "$" + String(ride["estimated_cost_cents_max"].doubleValue / 100.0)
                    }
                    if ride["display_name"].stringValue == "Lyft Plus" {
                        lyftFares.lyftPlus = "$" + String(ride["estimated_cost_cents_max"].doubleValue / 100.0)
                    }
                    if ride["display_name"].stringValue == "Lyft Premier" {
                        lyftFares.lyftPremier = "$" + String(ride["estimated_cost_cents_max"].doubleValue / 100.0)
                    }
                    if ride["display_name"].stringValue == "Lyft Lux" {
                        lyftFares.lyftLux = "$" + String(ride["estimated_cost_cents_max"].doubleValue / 100.0)
                    }
                    if ride["display_name"].stringValue == "Lyft Lux SUV" {
                        lyftFares.lyftLuxSUV = "$" + String(ride["estimated_cost_cents_max"].doubleValue / 100.0)
                    }
                }
                print("lyftFares: \(lyftFares)")
            case .failure(let error):
                print(error)
            }
            completion(lyftFares)
        }
    }
}
