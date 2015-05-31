//
//  HTTPClient.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/30/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import Foundation

import TwitterKit
import SwiftyJSON
import PromiseKit
import SnapKit
import Alamofire

class HTTPClient {
    
    class func getUserStatusJSON(callBack: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void ) {
        
        let twitterUserEndpoint = "https://api.twitter.com/1.1/users/show.json"
        var clientError : NSError?
        
        var params = ["screen_name": Twitter.sharedInstance().session().userName]
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: twitterUserEndpoint, parameters: params, error: &clientError)
        if request != nil {
            
//            Alamofire.request(.GET, "https://gist.githubusercontent.com/alcedo/5aa8ce42f516a68d52e5/raw/d29598982ed212eedc8ae8515cbdf7e94d168f1c/user_status")
//                .responseJSON { (request, response, data, error) in
//                    callBack(request, response, data, error);
//            }
            
                Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                    (response, data, connectionError) -> Void in
                    if (connectionError == nil) {
                        var jsonError : NSError?
                        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
                        callBack(request,nil,json!, connectionError)
                    }else {
                        println("Error: \(connectionError)")
                    }
                }
            
        }else {
            println("Error: \(clientError)")
        }
    }
}