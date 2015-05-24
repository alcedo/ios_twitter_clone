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
import Alamofire
import SVProgressHUD

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TWTRTweetViewDelegate {
    
    var tweets: JSON?
    let tweetTableReuseIdentifier = "TweetCell"
    var tableView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    var tweetData: [TWTRTweet] = [] {
        didSet {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
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
        
        // refresh control 
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "didRefreshTableView", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl)
    }
    
    func didTapLogOutButton() {
        println("log out")
    }
    
    func didTapNewTweetButton() {
        let vc = ComposeTweetViewController()
        let nvc = UINavigationController(rootViewController: vc)
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
    func didRefreshTableView() {
        self.loadTweet()
    }
    
    func loadTweet() {
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        var clientError : NSError?
        let request = Twitter.sharedInstance().APIClient.URLRequestWithMethod("GET", URL: statusesShowEndpoint, parameters: nil, error: &clientError)
        if request != nil {
            
//            Alamofire.request(.GET, "https://gist.githubusercontent.com/alcedo/5aa8ce42f516a68d52e5/raw/0334bf9f825cbc2f8c8978f4aa43f287745de1fa/twitter_home")
//                .responseJSON { (request, response, data, error) in
//                    self.tweetData = TWTRTweet.tweetsWithJSONArray(data as! [AnyObject]) as! [TWTRTweet]
//                    self.tweets = JSON(data!)
//                }
//
            Twitter.sharedInstance().APIClient.sendTwitterRequest(request) {
                (response, data, connectionError) -> Void in
                if (connectionError == nil) {
                    var jsonError : NSError?
                    let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError)
                    self.tweets = JSON(json!)
                    if let jsonArray = json as? NSArray {
                        self.tweetData = TWTRTweet.tweetsWithJSONArray(jsonArray as [AnyObject]) as! [TWTRTweet]
                        println(jsonArray)
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
        cell.tweetView.tag = indexPath.row
        let ab = ActionBarView()
        ab.delegate = self
        ab.indexPath = indexPath
        cell.contentView.addSubview(ab)
        ab.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(cell.contentView.snp_bottom).offset(-25)
            make.left.equalTo(cell.contentView.snp_left).offset(40)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tweetId = self.tweets![indexPath.row]["id_str"]
        self.showDetailedTweet(tweetId.stringValue, tweetData: self.tweets![indexPath.row])
    }
    
    func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!) {
        let tweetId = self.tweets![tweetView.tag]["id_str"]
        self.showDetailedTweet(tweetId.stringValue, tweetData: self.tweets![tweetView.tag])
    }
    
    func showDetailedTweet(id: String, tweetData: JSON) {
        let vc = ViewTweetViewController()
        vc.tweetData = tweetData
        vc.tweetId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = self.tweetData[indexPath.row]
        return TWTRTweetTableViewCell.heightForTweet(tweet, width: CGRectGetWidth(self.view.bounds)) + 20
    }
    
}

extension MainViewController: TweetActionDelegate {
    func didTapTweetReplyButton(indexPath: NSIndexPath) {
        println("tap on reply btn: \(indexPath.row)")
        let vc = ComposeTweetViewController()
        let nvc = UINavigationController(rootViewController: vc)
        let replyTarget = self.tweets![indexPath.row]["user"]["screen_name"]
        vc.tweetText = "@\(replyTarget.stringValue) "
        self.presentViewController(nvc, animated: true, completion: nil)
    }
    
    func didTapTweetStarButton(indexPath: NSIndexPath) {
        println("tap on star btn: \(indexPath.row)")
        SVProgressHUD.showSuccessWithStatus("Starred successful")
    }
}

