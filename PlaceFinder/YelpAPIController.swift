//
//  YelpAPIController.swift
//  PlaceFinder
//
//  Created by Alla Bondarenko on 2017-03-12.
//  Copyright © 2017 SMU Student. All rights reserved.
//

import UIKit
import CoreLocation

//Defining a function that will pass parameters to all Classes that conform to this protocol.
//We'll return json results from Yelp API Business Search https://www.yelp.com/developers/documentation/v3/business_search
//More info about protocols see at https://developer.apple.com/library/prerelease/content/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html

protocol YelpAPIControllerProtocol {
    func didRecieveAPIResults( results: [[String: Any]])
}

class YelpAPIController {
    
    //Yelp Credentials
    let clientID = "Jb_4nQ5KWLejpoajGq6OCw"
    let clientSecret = "RdGewyDcpT31vltwSiYzUHGGgU4mTHUk1U3DR0FBBpi9ROSituk4qpRT8mvv3ST0"
    
    var delegate: YelpAPIControllerProtocol?
    
    
    //function that performs OAuth2.0 to yelp service
    func getAuthToken(callback: @escaping(String) -> ()){
        let session = URLSession.shared
        
        
        //creating url according to YelpAPI v3 https://www.yelp.com/developers/documentation/v3/get_started
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.yelp.com"
        urlComponents.path = "/oauth2/token"
        
        //Customizing url parameters
        if let url = urlComponents.url {
            let request = NSMutableURLRequest(url: url)
            //set http method
            request.httpMethod = "POST"
            
            //assigning parameters in http body
            let parameters = "grant_type=client_credentials&client_id=\(clientID)&client_secret=\(clientSecret)"
            //allow lossyconvertion -> allows characters to be removed or altered in conversion.
            request.httpBody = parameters.data(using: String.Encoding.ascii, allowLossyConversion: true)
            
            //setting content type header
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            //create data task, completion handler is something like a callback
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) -> Void in
                if (error != nil) {
                    print(error?.localizedDescription ?? "error")
                } else {
                    //parsing a return json and looking for access_token fields according to YELP API OAuth2.0 documentation
                    if let recievedData = data, let jsonResult = try? JSONSerialization.jsonObject(with: recievedData, options: []) as? [String: Any] {
                        print(jsonResult ?? "no result")
                        let tokenValue = jsonResult!["access_token"] as? String
                        //return relust back
                        callback(tokenValue!)
                    }
                }
            })
            
            //finally sending a request
            task.resume()
        }
        
    }
    
    
    //function that checks whether there's a token stored on the phone storage. NOT RECOMMENDED. Use Keychain https://developer.apple.com/reference/security/keychain_services
    //We're using it just because implementing Keychain Class is very time consuming
    func tokenStored() -> String? {
        var token: String?
        
        //if value is stored under key "yelpToken"
        if let tokenValue = UserDefaults.standard.value(forKey: "yelpToken") as? String {
            //assign it to local variable
            token = tokenValue
        } else {
            //otherwise perform an authorization request
            getAuthToken() { (response) in
                let tokenValue = response
                //save it on the phone
                UserDefaults.standard.setValue(tokenValue, forKey: "yelpToken")
                UserDefaults.standard.synchronize()
                //assign token to local variable
                token = tokenValue
            }
        }
       return token
    }
    
    
    
    //request to Business Search API https://www.yelp.com/developers/documentation/v3/business_search
    
    func getBusinessSearch( location: CLLocation, term: String ) {
        let session = URLSession.shared
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.yelp.com"
        urlComponents.path = "/v3/businesses/search"
        
        //check whether the token is stored
        guard let token = tokenStored() else {
            print("no token stored")
            return
        }
        
        //default radius around user's current location. There's a limitation
        let radius = 5000
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        //setting query parameters, including user input "term" and current location coordinates
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: String(term)),
            URLQueryItem(name: "radius", value: String(radius)),
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude))
        ]
        
        
        //check if url is valid
        if let url = urlComponents.url {
            var request = URLRequest(url: url)
            //assign auth header
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            //prepare a task with a completion handler.
            let task = session.dataTask(with: request as URLRequest, completionHandler: {
                (data, response, error) -> Void in
                
                if (error != nil) {
                    print("error", error?.localizedDescription ?? "")
                } else {
                    //trying to parse recieved data with json serializer. Expecting json as a big Dictionary of type [String : Any]
                if let receivedData = data, let jsonResult = try? JSONSerialization.jsonObject(with: receivedData, options: .allowFragments) as? [String: Any]{
                        print(jsonResult!)
                    //if successful and there's anything under key "businesses" and can be casted as an array of json objects
                    if let businesses = jsonResult!["businesses"] as? [[String: Any]] {
                        
                        //returning it back through delegate method
                        self.delegate?.didRecieveAPIResults(results: businesses)
                    }
                    
                }
                    
            }
        })
            
            //performing a task
        task.resume()
            
        }        
    }
    
    
    
    
    
    
}
