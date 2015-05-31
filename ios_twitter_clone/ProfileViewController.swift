//
//  ProfileViewController.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/30/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit
import UIKit
import TwitterKit
import SwiftyJSON
import PromiseKit
import SnapKit
import Alamofire

class ProfileViewController: UIViewController {
    
    var userDetails: JSON?
    
    var userProfileImage: UIImageView!
    var userName: UILabel!
    var userTweetCount: UILabel!
    var userFollowers: UILabel!
    var userFollowing: UILabel!

    var statusText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "didTapCloseButton")
        self.loadTweet()
    }
    
    func buildView() {
        UIGraphicsBeginImageContext(self.view.frame.size)
        let url = NSURL(string: self.userDetails!["profile_banner_url"].stringValue)
        let imageData = NSData(contentsOfURL: url!)
        UIImage(data: imageData!)?.drawInRect(self.view.bounds)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
        
        self.userProfileImage = UIImageView()
        self.view.addSubview(self.userProfileImage)
        var profileUrl = self.userDetails!["profile_image_url"].stringValue
        profileUrl = profileUrl.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.userProfileImage.setImageWithURL(NSURL(string: profileUrl))
        
        self.userName = UILabel(frame: CGRectMake(0, 0, 100, 40))
        self.userName.text = self.userDetails!["name"].stringValue
        self.userName.textColor = UIColor.whiteColor()
        self.userName.sizeToFit()
        self.view.addSubview(self.userName)
        
        self.userTweetCount = UILabel()
        
        let tweetCount = self.userDetails!["statuses_count"].stringValue
        self.userTweetCount.text = "TWEETS: \(tweetCount)"
        self.userTweetCount.textColor = UIColor.whiteColor()
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
        
        self.statusText = UITextView()
        self.statusText.editable = false
        self.statusText.backgroundColor = UIColor.clearColor()
        self.statusText.text = self.userDetails!["status"]["text"].stringValue
        self.view.addSubview(self.statusText)
        self.statusText.font = UIFont(name: "Helvetica", size: 20)
        self.statusText.textColor = self.userTweetCount.textColor
    }
    
    func setupConstraint() {
        let marginLeft = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let rowSpacing = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        self.userProfileImage.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(80)
            make.left.equalTo(self.view).insets(marginLeft)
            make.width.equalTo(60)
            make.height.equalTo(80)
        }
        
        self.userName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view).offset(80)
            make.left.equalTo(self.userProfileImage.snp_right).offset(10)
        }

        self.userTweetCount.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.userName.snp_bottom)
            make.left.equalTo(self.userProfileImage.snp_right).offset(10)
        }
        
        self.userFollowers.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.userTweetCount.snp_bottom).insets(rowSpacing)
            make.left.equalTo(self.userProfileImage.snp_right).offset(10)
        }
        
        self.userFollowing.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.userFollowers.snp_bottom).insets(rowSpacing)
            make.left.equalTo(self.userProfileImage.snp_right).offset(10)
        }
        
        self.statusText.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.userFollowing.snp_bottom).insets(rowSpacing)
            make.center.equalTo(self.view)
            make.width.equalTo(self.view.frame.width - 20)
            make.height.equalTo(300)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadTweet() {
        let twitterUserEndpoint = "https://api.twitter.com/1.1/users/show.json"
        var clientError : NSError?
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: twitterUserEndpoint, parameters: nil, error: &clientError)
        if request != nil {
            HTTPClient.getUserStatusJSON({ (request, response, data, error) -> Void in
                self.userDetails = JSON(data!)
                self.buildView()
                self.setupConstraint()
            })
            
        }else {
            println("Error: \(clientError)")
        }
    }
    
    func didTapCloseButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
