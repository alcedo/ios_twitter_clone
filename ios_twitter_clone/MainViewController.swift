//
//  MainViewController.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/21/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit
import TwitterKit
import SwiftyJSON
import PromiseKit
import SnapKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TWTRTweetViewDelegate {
    
    var tweets: JSON?
    let tweetTableReuseIdentifier = "TweetCell"
    var tableView: UITableView!
    
    var tweetData: [TWTRTweet] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Tweets"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: .Plain, target: self, action: "didTapLogOutButton")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "didTapNewTweetButton")
        self.loadTweet()
        self.buildView()
    }
    
    func buildView() {
        self.tableView = UITableView()
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)
    }
    
    func didTapLogOutButton() {
        println("log out")
    }
    
    func didTapNewTweetButton() {
        println("new tweet")
        
    }
    
    func loadTweet() {
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        var clientError : NSError?
        
        var maxId = "10"
        if let tweets = self.tweets {
            maxId = tweets[tweets.count]["id_str"].stringValue
        }
        let params = ["since_id": maxId]
        
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: params, error: &clientError)
        
        if request != nil {
            
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
                    self.tweets = JSON(json!)
                    if let jsonArray = json as? NSArray {
                        self.tweetData = TWTRTweet.tweetsWithJSONArray(jsonArray as [AnyObject]) as! [TWTRTweet]
                    }
                    println(self.tweets![0]["text"])
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
    
    // MARK: UITableViewDelegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(self.tweetData.count)
        return self.tweetData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = self.tweetData[indexPath.row]
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.tweetTableReuseIdentifier, forIndexPath: indexPath) as! TWTRTweetTableViewCell
        cell.configureWithTweet(tweet)
        cell.tweetView.delegate = self
        let ab = ActionBarView()
        cell.contentView.addSubview(ab)
        ab.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(cell.contentView.snp_bottom)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = self.tweetData[indexPath.row]
        return TWTRTweetTableViewCell.heightForTweet(tweet, width: CGRectGetWidth(self.view.bounds))
    }
}
