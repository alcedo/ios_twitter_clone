//
//  ComposeTweetViewController.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/23/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {
    
    var composeField: UITextView!

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
        self.composeField.delegate = self
        self.view.addSubview(self.composeField)
        self.composeField.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    func didTapCancelButton() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func didTapTweetButton() {
        println("tweet initiated")
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
