//
//  ActionBarView.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/22/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit
import SnapKit

class ActionBarView: UIView {

    var reply: UIButton!
    var retweet: UIButton!
    var star: UIButton!
    
    convenience init() {
        self.init(frame: CGRectZero)
        
        self.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(400)
            make.height.equalTo(20)
        }
        
        self.reply = UIButton()
        let replyImage = UIImage(named: "reply")
        self.reply.setImage(replyImage, forState: UIControlState.Normal)
        self.addSubview(self.reply)
        self.reply.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(self)
        }
        
        self.star = UIButton()
        let starImage = UIImage(named: "star")
        self.star.setImage(starImage, forState: UIControlState.Normal)
        self.addSubview(self.star)
        self.star.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self)
            make.left.equalTo(self.reply.snp_right).offset(30)
        }
        
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
