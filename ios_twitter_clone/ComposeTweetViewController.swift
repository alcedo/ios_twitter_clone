//
//  ComposeTweetViewController.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/23/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit
import TwitterKit
import SwiftyJSON

class ComposeTweetViewController: UIViewController, UITextViewDelegate {
    
    var composeField: UITextView!
    var tweetText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "didTapCancelButton")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .Plain, target: self, action: "didTapTweetButton")
        self.buildView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func buildView() {
        self.composeField = UITextView()
        self.composeField.text = self.tweetText
        self.composeField.delegate = self
        self.view.addSubview(self.composeField)
        self.composeField.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        self.composeField.becomeFirstResponder()
    }
    
    func didTapCancelButton() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapTweetButton() {
        self.postTweet()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView) {
        self.tweetText = textView.text
    }

    func postTweet() {
        let endPoint = "https://api.twitter.com/1.1/statuses/update.json"
        var clientError : NSError?
        let params = ["status": self.tweetText]
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("POST", URL: endPoint, parameters: params, error: &clientError)
        
        if request != nil {
            
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
                    println(json!)
//                    self.tweets = JSON(json!)
//                    if let jsonArray = json as? NSArray {
//                        self.tweetData = TWTRTweet.tweetsWithJSONArray(jsonArray as [AnyObject]) as! [TWTRTweet]
//                        println(jsonArray)
//                    }
                }else {
                    println("Error: \(connectionError)")
                }
            }
            
        }else {
            println("Error: \(clientError)")
        }
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
