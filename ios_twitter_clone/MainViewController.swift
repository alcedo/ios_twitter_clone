//
//  MainViewController.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/21/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit
import TwitterKit

class MainViewController: UIViewController {
    
    var tweets: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.loadTweet()
    }
    
    func loadTweet() {
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        var clientError : NSError?
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: nil, error: &clientError)
        
        if request != nil {
            
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
                }else {
                    println("Error: \(connectionError)")
                }
            }
        }else {
            println("Error: \(clientError)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
