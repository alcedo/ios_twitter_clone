//
//  Auth.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/21/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import Foundation
import TwitterKit

class Auth: NSObject {
    
    class func getUserId() -> String? {
        if let session = Twitter.sharedInstance().session() {
            return session.userID
        }else {
            return nil
        }
    }
    
    class func doLogin() {
        
    }
    
    class func getGuestAuth() {
        
        Twitter.sharedInstance().logInGuestWithCompletion { guestSession, error in
            if (guestSession != nil) {
            // make API calls that do not require user auth
            
            } else {
                println("error: \(error.localizedDescription)");
            }
        }
    }
    
    
}