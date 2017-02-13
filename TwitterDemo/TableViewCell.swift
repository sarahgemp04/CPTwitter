//
//  TableViewCell.swift
//  TwitterDemo
//
//  Created by Sarah Gemperle on 2/6/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit
import AFNetworking

class TableViewCell: UITableViewCell {

    var tweet: Tweet?
    
    var favHolderCount: Int = 0
    var retweetHolderCount: Int = 0
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var favImg: UIImageView!
    @IBOutlet weak var retweetImg: UIImageView!
    @IBOutlet weak var favCount: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var timeSince: UILabel!
    
    func setup() {
        
        let imgURL = tweet!.tweeter!.profileURL
        imgView.setImageWith(imgURL!)

        retweetHolderCount = tweet!.retweet
        favHolderCount = tweet!.favorites
        
        refreshTweetStatus()
        imgView.layer.cornerRadius = 5
        
        tweetText.text = tweet!.tweetText
        handle.text = ("\(tweet!.handle!)")
       
        nameLabel.text = tweet!.tweeter!.name! as String
        
        timeSince.text = tweet!.dateTweeted!
        
        imgView.setImageWith(tweet!.tweeter!.profileURL!)
        
    }
    
    func refreshTweetStatus() {
        
        if tweet!.isFavorited {
            favImg.image = #imageLiteral(resourceName: "favor-icon-red")
        } else {
            favImg.image = #imageLiteral(resourceName: "favor-icon")
        }
        favCount.text = "\(favHolderCount)"
        
        if tweet!.isRetweeted {
            retweetImg.image = #imageLiteral(resourceName: "retweet-icon-green")
        } else {
            retweetImg.image = #imageLiteral(resourceName: "retweet-icon")
        }
        retweetCount.text = "\(retweetHolderCount)"

    }
    
    func onRetweetTap() {
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
        
        let retweetTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TableViewCell.onRetweetTap))
        let favoriteTapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TableViewCell.onFavoriteTap))
        
        self.retweetImg.addGestureRecognizer(retweetTapRecognizer)
        self.favImg.addGestureRecognizer(favoriteTapRecognizer)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
