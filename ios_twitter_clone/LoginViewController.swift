//
//  ViewController.swift
//  ios_twitter_clone
//
//  Created by Victor Liew on 5/21/15.
//  Copyright (c) 2015 alcedo. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    func showView() {
        if let userId = Auth.getUserId() {
            self.showMainViewController()
        }else {
            self.showLoginView()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.showView()
    }
    
    func showLoginView() {
        let logInButton = TWTRLogInButton(logInCompletion: {
            (session: TWTRSession!, error: NSError!) in
            self.showView()
            
            if (session != nil) {
                println("signed in as \(session.userName)");
            } else {
                println("error: \(error.localizedDescription)");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
    }
    
    func showMainViewController() {
        let vc = MainViewController()
        let nvc = UINavigationController(rootViewController: vc)
        self.presentViewController(nvc, animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

