//
//  ComposeViewController.swift
//  TwitterDemo
//
//  Created by Sarah Gemperle on 2/20/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var profImageView: UIImageView!
    @IBOutlet weak var tweetTextField: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profImageView.setImageWith(User.currentUser!.profileURL!)
        
        profImageView.layer.cornerRadius = 5
        tweetTextField.layer.borderWidth = 1
        tweetTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        tweetButton.layer.cornerRadius = 5

        
        self.tweetTextField.becomeFirstResponder()
        
    }

    @IBAction func tweetButtonPressed(_ sender: AnyObject) {
        
        let text = tweetTextField.text
        TwitterClient.sharedInstance!.tweet(tweet: text! , success: { (tweet: Tweet) in
        self.tweetTextField.resignFirstResponder()
        self.tweetTextField.endEditing(true)
        self.dismiss(animated: true, completion: nil)
            
        }) { (error: Error) in
            print(error.localizedDescription)
        }
    }
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
