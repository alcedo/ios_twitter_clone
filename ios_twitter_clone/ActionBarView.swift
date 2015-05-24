//
//  ActionBarView.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/22/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol TweetActionDelegate {
    optional func didTapTweetReplyButton(indexPath: NSIndexPath)
    optional func didTapTweetStarButton(indexPath: NSIndexPath)
    optional func didTapTweetRetweetButton(indexPath: NSIndexPath)
    
    optional func didTapTweetReplyButton()
    optional func didTapTweetStarButton()
    optional func didTapTweetRetweetButton()
}

class ActionBarView: UIView {

    var reply: UIButton!
    var retweet: UIButton!
    var star: UIButton!
    var indexPath: NSIndexPath!
    var delegate: TweetActionDelegate?
    
    convenience init() {
        self.init(frame: CGRectZero)
        
        self.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(400)
            make.height.equalTo(55)
        }
        
        let iconSize = 15
        
        self.reply = UIButton()
        let replyImage = UIImage(named: "reply")
        self.reply.addTarget(self, action: "didTapReplyButton", forControlEvents: UIControlEvents.TouchUpInside)
        self.reply.setImage(replyImage, forState: UIControlState.Normal)
        self.addSubview(self.reply)
        self.reply.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(self)
            make.width.height.equalTo(iconSize)
        }
        
        self.star = UIButton()
        self.star.addTarget(self, action: "didTapStarButton", forControlEvents: UIControlEvents.TouchUpInside)
        let starImage = UIImage(named: "star")
        self.star.setImage(starImage, forState: UIControlState.Normal)
        self.addSubview(self.star)
        self.star.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(iconSize)
            make.top.equalTo(self)
            make.left.equalTo(self.reply.snp_right).offset(30)
        }
        
        
        self.retweet = UIButton()
        self.retweet.addTarget(self, action: "didTapRetweetButton", forControlEvents: UIControlEvents.TouchUpInside)
        let retweetImage = UIImage(named: "retweet")
        self.retweet.setImage(retweetImage, forState: UIControlState.Normal)
        self.addSubview(self.retweet)
        self.retweet.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(iconSize)
            make.top.equalTo(self)
            make.left.equalTo(self.star.snp_right).offset(30)
        }
        
    }
    
    func didTapRetweetButton() {
        if let d = self.delegate {
            if let path = self.indexPath {
                d.didTapTweetRetweetButton!(self.indexPath)
            } else {
                d.didTapTweetRetweetButton!()
            }
        }
    }
    
    func didTapReplyButton() {
        if let d = self.delegate {
            if let path = self.indexPath {
                d.didTapTweetReplyButton!(self.indexPath)
            } else {
                d.didTapTweetReplyButton!()
            }
        }
    }
    
    func didTapStarButton() {
        if let d = self.delegate {
            if let path = self.indexPath {
                d.didTapTweetStarButton!(self.indexPath)
            } else {
                d.didTapTweetStarButton!()
            }
        }
    }
    
}
