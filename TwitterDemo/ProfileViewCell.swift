//
//  ProfileViewCell.swift
//  TwitterDemo
//
//  Created by Sarah Gemperle on 2/20/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {

    var tweet: Tweet?
    
    var favHolderCount: Int = 0
    var retweetHolderCount: Int = 0
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeSinceLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var favImgView: UIImageView!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favCount: UILabel!
    @IBOutlet weak var retweetImgView: UIImageView!
    
    func setup() {
        
        let imgURL = tweet!.tweeter!.profileURL
        imgView.setImageWith(imgURL!)
        
        retweetHolderCount = tweet!.retweet
        favHolderCount = tweet!.favorites
        
        refreshTweetStatus()
        imgView.layer.cornerRadius = 5
        
        tweetText.text = tweet!.tweetText
        screenNameLabel.text = ("\(tweet!.handle!)")
        
        nameLabel.text = tweet!.tweeter!.name! as String
        
        timeSinceLabel.text = tweet!.dateTweeted!
        
        imgView.setImageWith(tweet!.tweeter!.profileURL!)
        
    }
    
    func refreshTweetStatus() {
        
        if tweet!.isFavorited {
            favImgView.image = #imageLiteral(resourceName: "favor-icon-red")
        } else {
            favImgView.image = #imageLiteral(resourceName: "favor-icon")
        }
        favCount.text = "\(favHolderCount)"
        
        if tweet!.isRetweeted {
            retweetImgView.image = #imageLiteral(resourceName: "retweet-icon-green")
        } else {
            retweetImgView.image = #imageLiteral(resourceName: "retweet-icon")
        }
        retweetCount.text = "\(retweetHolderCount)"
        
    }
    
    func onRetweetTap() {
        
        if tweet!.isRetweeted {
            return
        }
        
        let client = TwitterClient.sharedInstance!
        
        client.retweet(currTweet: self.tweet!, success: { (int: Int) in
            self.retweetHolderCount = int
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
            self.favHolderCount = int
            self.tweet?.isFavorited = true
            self.refreshTweetStatus()
            
        }) { (error: Error?) in
            print("Error favoriting: \(error)")
        }
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let retweetTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TableViewCell.onRetweetTap))
        let favoriteTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TableViewCell.onFavoriteTap))
        
        self.retweetImgView.addGestureRecognizer(retweetTapRecognizer)
        self.favImgView.addGestureRecognizer(favoriteTapRecognizer)

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
