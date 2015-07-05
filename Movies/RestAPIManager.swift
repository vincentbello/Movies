//
//  RestAPIManager.swift
//  Movies
//
//  Created by Vincent Bello on 6/20/15.
//  Copyright (c) 2015 Vincent Bello. All rights reserved.
//

import UIKit

typealias ServiceResponse = (JSON, NSError?) -> Void

class RestAPIManager: NSObject {
    
    static let sharedInstance = RestAPIManager()
    
    let baseURL = "http://api.readyto.watch/"
    
    func getRequest(dataSourceURL: String, onCompletion: (JSON) -> Void) {
        let route = dataSourceURL
        
        makeHTTPGetRequest(route, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            let json: JSON = JSON(data: data)
            onCompletion(json, error)
        })
        
        task.resume()
    }
    
    
    func makeHTTPPostRequest(path: String, body: [String: AnyObject], onCompletion: ServiceResponse) {
        var err: NSError?
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        // Set the method to POST
        request.HTTPMethod = "POST"
        
        // Set the POST body for the request
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body, options: nil, error: &err)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json: JSON = JSON(data: data)
            onCompletion(json, err)
        })
        
        task.resume()
    }
    
    
   
}
