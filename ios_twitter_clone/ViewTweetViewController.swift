//
//  ComposeTweetViewController.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/23/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit
import TwitterKit
import SVProgressHUD

class ViewTweetViewController: UIViewController, TweetActionDelegate {

    var tweetBody: TWTRTweetView!
    var tweetId: String!
    var tweet: TWTRTweet? {
        didSet {
            self.buildView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTweet()
        self.view.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadTweet() {
        Twitter.sharedInstance().APIClient.loadTweetWithID(self.tweetId) {
            (tweet, error) -> Void in
            
            if (tweet != nil) {
                self.tweet = tweet
            }else {
                println("err loading tweet")
            }
        }
    }

    func buildView() {
        self.tweetBody = TWTRTweetView(tweet: self.tweet, style: TWTRTweetViewStyle.Compact)
        self.view.addSubview(self.tweetBody)
        self.tweetBody.snp_makeConstraints { (make) -> Void in
            make.right.left.equalTo(self.view)
            make.top.equalTo((self.topLayoutGuide as! UIView).snp_bottom)
            return
        }
        
        // Action bar
        let ab = ActionBarView()
        ab.delegate = self
        self.view.addSubview(ab)
        ab.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.tweetBody.snp_bottom).offset(10)
            make.left.equalTo(self.tweetBody).offset(20)
        }
        
        let horizontalLine = UIView()
        horizontalLine.backgroundColor = UIColor(hex: "#F3F3F3")
        self.view.addSubview(horizontalLine)
        horizontalLine.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(1)
            make.top.equalTo(ab.snp_bottom).offset(-30)
            make.width.equalTo(self.tweetBody)
        }
        

    }
    
    func didTapTweetReplyButton() {
        println("view tweet reply")
        SVProgressHUD.showSuccessWithStatus("Reply successful")
    }
    func didTapTweetStarButton() {
        println("view tweet star")
        SVProgressHUD.showSuccessWithStatus("Starred successful")
    }
    
}
