//
//  Business.swift
//  PlaceFinder
//
//  Created by Alla Bondarenko on 2017-03-12.
//  Copyright © 2017 SMU Student. All rights reserved.
//

import Foundation
import CoreLocation

//Data Model for Search Business API Response body. Not all fields are collected. See https://www.yelp.com/developers/documentation/v3/business_search section Response Body
class Business {
    var name: String!
    var rating: Int?
    var price: String?
    var phone: String?
    var id: String?
    var isClosed: Bool?
    var coordinates: CLLocation!
    var url: URL! //String?
    var img_url: URL?
    var distance: String?
    var categories: String?
    
    
    //default initializer is a json object parser.
    init?(json: [String: Any]) {
        //using guard to make sure all required field are present. See Early Exit section of https://developer.apple.com/library/prerelease/content/documentation/Swift/Conceptual/Swift_Programming_Language/ControlFlow.html#//apple_ref/doc/uid/TP40014097-CH9-ID525
        
        guard let name = json["name"] as? String else {
            return nil
        }
        
        guard let distance = json["distance"] as? Double else {
            return nil
        }
        
        guard let phone = json["phone"] as? String else {
            return nil
        }
        
        guard let isClosed = json["is_closed"] as? Bool else {
            return nil
        }
        
        //parsing nested json for category objects
        guard let categories = json["categories"] as? [[String: Any]] else {
            return nil
        }
        
        var categoriesStr = ""
        for category in categories {
            if let category = category["title"] as? String {
                categoriesStr.append("\(category) ")
            }
        }
        
        guard let img_url = json["image_url"] as? String else {
            return nil
        }
        
        // Parsing an nested json for category objects. Extract and validate coordinates.
        guard let coordinatesJSON = json["coordinates"] as? [String: Double],
            let latitude = coordinatesJSON["latitude"],
            let longitude = coordinatesJSON["longitude"]
            else {
                return nil
        }
        
        
        self.name = name
        self.distance = String(format: "%.0f", distance).appending(" meters")
        self.phone = phone
        self.isClosed = isClosed
        self.categories = categoriesStr
        self.img_url = URL(string: img_url)
        self.coordinates = CLLocation(latitude: latitude, longitude: longitude)
        
    }
}
