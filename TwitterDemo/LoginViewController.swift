//
//  LoginViewController.swift
//  TwitterDemo
//
//  Created by Sarah Gemperle on 2/3/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.image = #imageLiteral(resourceName: "Twitter_Logo_Blue-1")
        loginButton.layer.cornerRadius = 10
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButtonClick(_ sender: AnyObject) {
        
        TwitterClient.sharedInstance!.login(success: {
            print("I've logged in!")
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }) { (error: Error?) in
            print("Login error: \(error?.localizedDescription)")
        }
        
    }

}
