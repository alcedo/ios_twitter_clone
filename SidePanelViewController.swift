//
//  SidePanelViewController.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/30/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit
import TwitterKit
import SwiftyJSON
import PromiseKit
import SnapKit
import Alamofire

class SidePanelViewController: UIViewController {
    var profileLinkCallBack: (() -> Void)?
    var homeLinkCallBack: (() -> Void)?

    var userDetails: JSON?
    
    var userProfileImage: UIImageView!
    var userName: UILabel!
    var userTweetCount: UILabel!
    var userFollowers: UILabel!
    var userFollowing: UILabel!
    
    var profileLink: UITableViewCell!
    var homeTimelineLink: UITableViewCell!
    var mentionsLink: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: "#EEEEEE")
        self.title = "Settings View"
        
        self.loadTweet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildView() {
        let tapProfileGesture = UITapGestureRecognizer(target: self, action: "didTapProfileLink")
        let tapHomeGesture = UITapGestureRecognizer(target: self, action: "didTapHomeLink")
        
        self.userProfileImage = UIImageView()
        self.view.addSubview(self.userProfileImage)
        var profileUrl = self.userDetails!["profile_image_url"].stringValue
        profileUrl = profileUrl.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.userProfileImage.setImageWithURL(NSURL(string: profileUrl))
        
        self.userName = UILabel()
        self.userName.userInteractionEnabled = true
        self.userName.text = self.userDetails!["name"].stringValue
        self.view.addSubview(self.userName)
        
        self.userTweetCount = UILabel()
        
        let tweetCount = self.userDetails!["statuses_count"].stringValue
        self.userTweetCount.text = "TWEETS: \(tweetCount)"
        self.userTweetCount.textColor = UIColor(hex: "#2c3e50")
        self.view.addSubview(self.userTweetCount)
        
        self.userFollowers = UILabel()
        let followerCount = self.userDetails!["followers_count"].stringValue
        self.userFollowers.text = "FOLLOWERS: \(followerCount)"
        self.userFollowers.textColor = self.userTweetCount.textColor
        self.view.addSubview(self.userFollowers)
        
        self.userFollowing = UILabel()
        let friendCount = self.userDetails!["friends_count"].stringValue
        self.userFollowing.text = "FOLLOWING: \(friendCount)"
        self.userFollowing.textColor = self.userTweetCount.textColor
        self.view.addSubview(self.userFollowing)
        
        self.profileLink = UITableViewCell()
        self.profileLink.addGestureRecognizer(tapProfileGesture)
        self.profileLink.backgroundColor = UIColor.whiteColor()
        self.profileLink.imageView!.image = UIImage(named: "profile")
        self.profileLink.textLabel?.text = "View Profile"
        self.view.addSubview(self.profileLink)
        
        self.homeTimelineLink = UITableViewCell()
        self.homeTimelineLink.addGestureRecognizer(tapHomeGesture)
        self.homeTimelineLink.backgroundColor = self.profileLink.backgroundColor
        self.homeTimelineLink.imageView!.image = UIImage(named: "home")
        self.homeTimelineLink.textLabel?.text = "Home Time Line"
        self.view.addSubview(self.homeTimelineLink)
        
        self.mentionsLink = UITableViewCell()
        self.mentionsLink.backgroundColor = self.profileLink.backgroundColor
        self.mentionsLink.imageView!.image = UIImage(named: "mentions")
        self.mentionsLink.textLabel?.text = "Mentions"
        self.view.addSubview(self.mentionsLink)
        
    }
    
    func setupConstraint() {
        let marginLeft = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let rowSpacing = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.userProfileImage.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(40)
            make.left.equalTo(self.view).insets(marginLeft)
            make.width.equalTo(60)
            make.height.equalTo(80)
        }
        
        self.userName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(40)
            make.left.equalTo(self.userProfileImage.snp_right).insets(marginLeft).offset(10)
        }
        
        self.userTweetCount.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.userName.snp_bottom).insets(rowSpacing)
            make.left.equalTo(self.userProfileImage.snp_right).insets(marginLeft).offset(10)
        }
        
        self.userFollowers.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.userTweetCount.snp_bottom).insets(rowSpacing)
            make.left.equalTo(self.userProfileImage.snp_right).insets(marginLeft).offset(10)
        }
        
        self.userFollowing.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.userFollowers.snp_bottom).insets(rowSpacing)
            make.left.equalTo(self.userProfileImage.snp_right).insets(marginLeft).offset(10)
        }
        
        let tableRowHeight = 40
        self.profileLink.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(tableRowHeight)
            make.width.equalTo(self.view)
            make.top.equalTo(self.userFollowing.snp_bottom).insets(rowSpacing)
            make.left.equalTo(self.view)
        }
        
        self.homeTimelineLink.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(tableRowHeight)
            make.width.equalTo(self.view)
            make.top.equalTo(self.profileLink.snp_bottom).insets(rowSpacing).offset(10)
            make.left.equalTo(self.view)
        }
        
        self.mentionsLink.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(tableRowHeight)
            make.width.equalTo(self.view)
            make.top.equalTo(self.homeTimelineLink.snp_bottom).insets(rowSpacing).offset(10)
            make.left.equalTo(self.view)
        }
    }
    
    
    func didTapProfileLink() {
        if let cb = self.profileLinkCallBack {
            cb()
        }
    }
    
    func didTapHomeLink() {
        if let cb = self.homeLinkCallBack {
            cb()
        }
    }
}

extension SidePanelViewController {
    func loadTweet() {
        let twitterUserEndpoint = "https://api.twitter.com/1.1/users/show.json"
        var clientError : NSError?
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: twitterUserEndpoint, parameters: nil, error: &clientError)
        if request != nil {
            HTTPClient.getUserStatusJSON({ (request, response, data, error) -> Void in
                self.userDetails = JSON(data!)
                println(self.userDetails!["profile_image_url"]);
                self.buildView()
                self.setupConstraint()
            })
            
        }else {
            println("Error: \(clientError)")
        }
    }
}
