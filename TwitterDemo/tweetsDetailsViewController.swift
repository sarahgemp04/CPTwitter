//
//  tweetsDetailsViewController.swift
//  TwitterDemo
//
//  Created by Sarah Gemperle on 2/19/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit

class tweetsDetailsViewController: UIViewController {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var favImageView: UIImageView!
    @IBOutlet weak var numRetweetsLabel: UILabel!
    @IBOutlet weak var numFavsLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    
    var tweet: Tweet?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let retweetTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TableViewCell.onRetweetTap))
        let favoriteTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TableViewCell.onFavoriteTap))
        
        self.retweetImageView.addGestureRecognizer(retweetTapRecognizer)
        self.favImageView.addGestureRecognizer(favoriteTapRecognizer)

        ProfileViewController.currUser = tweet!.tweeter!
        retweetCount = tweet!.retweet
        favoriteCount = tweet!.favorites
        if tweet != nil {
            setup()
        }
    }
    
    func setup() {
        
        profileImageView.layer.cornerRadius = 6
        profileImageView.setImageWith(tweet!.tweeter!.profileURL!)
        nameLabel.text = tweet!.tweeter!.name as String?
        handleLabel.text = tweet!.tweeter!.screenName as String?
        numRetweetsLabel.text = "\(tweet!.retweet)"
        numFavsLabel.text = "\(tweet!.favorites)"
        dateLabel.text = tweet!.dateTweeted
        tweetLabel.text = tweet!.tweetText!
        
        profileImageView.layer.cornerRadius = 5
        
        if(tweet!.isFavorited) {
            favImageView.image = #imageLiteral(resourceName: "favor-icon-red")
        } else {
            favImageView.image = #imageLiteral(resourceName: "favor-icon")
        }
        if(tweet!.isRetweeted) {
            retweetImageView.image = #imageLiteral(resourceName: "retweet-icon-green")
        } else {
            retweetImageView.image = #imageLiteral(resourceName: "retweet-icon")
        }
        
        replyImageView.image = #imageLiteral(resourceName: "reply-icon")
    }
    
    func refreshTweetStatus() {
        
        if tweet!.isFavorited {
            favImageView.image = #imageLiteral(resourceName: "favor-icon-red")
        } else {
            favImageView.image = #imageLiteral(resourceName: "favor-icon")
        }
        numFavsLabel.text = "\(favoriteCount)"
        
        if tweet!.isRetweeted {
            retweetImageView.image = #imageLiteral(resourceName: "retweet-icon-green")
        } else {
            retweetImageView.image = #imageLiteral(resourceName: "retweet-icon")
        }
        numRetweetsLabel.text = "\(retweetCount)"
        
    }
    @IBAction func profImageTapped(_ sender: AnyObject) {
         ProfileViewController.currUser = User.currentUser
         performSegue(withIdentifier: "ProfileSegue", sender: self)
    }
    
    func onRetweetTap() {
        
        if tweet!.isRetweeted {
            return
        }
        
        let client = TwitterClient.sharedInstance!
        
        client.retweet(currTweet: self.tweet!, success: { (int: Int) in
            self.retweetCount = int
            self.tweet?.isRetweeted = true
            self.refreshTweetStatus()
            
        }) { (error: Error?) in
            print("Error retweeting: \(error)")
        }
    }
    
    func onFavoriteTap() {
        if tweet!.isFavorited {
            return
        }
        
        let client = TwitterClient.sharedInstance!
        
        client.favorite(currTweet: self.tweet!, success: { (int: Int) in
            self.favoriteCount = int
            self.tweet?.isFavorited = true
            self.refreshTweetStatus()
            
        }) { (error: Error?) in
            print("Error favoriting: \(error)")
        }
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
