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
    
    func postRequest(dataSourceURL: String, body: [String: String], onCompletion: (JSON) -> Void) {
        let route = dataSourceURL
        
        makeHTTPPostRequest(route, body: body, onCompletion: { json, err in
            onCompletion(json as JSON)
        })
    }
    
    func makeHTTPGetRequest(path: String, onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            let json: JSON = JSON(data: data!)
            onCompletion(json, error)
        })
        
        task!.resume()
    }
    
    
    func makeHTTPPostRequest(path: String, body: [String: String], onCompletion: ServiceResponse) {
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        
        // Set the method to POST
        request.HTTPMethod = "POST"
        
        var params = [String]()
        for (key, val) in body {
            params.append("\(key)=\(val)")
        }
        let bodyData = "&".join(params)
        
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
//
//        do {
//            // Set the POST body for the request
////            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body, options: [])
//        } catch let error as NSError {
//            err = error
//            request.HTTPBody = nil
//        }
//
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            let json: JSON = JSON(data: data!)
            onCompletion(json, error)
        })
        
        task!.resume()
    }
    
    
   
}
