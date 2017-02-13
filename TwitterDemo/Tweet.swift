//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Sarah Gemperle on 2/5/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var tweetText: String?
    var dateTweeted: String?
    var retweet: Int = 0
    var tweeter: User?
    var favorites: Int = 0
    var handle: String?
    var tweetID: String?
    
    var isRetweeted: Bool
    var isFavorited: Bool
    
    init(dictionary: NSDictionary) {
        
        //Initialize tweet text, and retweet and fav count.
        tweetText = dictionary["text"] as? String
        retweet = (dictionary["retweet_count"]) as? Int ?? 0
        
        let status = dictionary["retweeted_status"] as? NSDictionary
        if status != nil {
            self.favorites = (status!["favorite_count"] as? Int) ?? 0
        } else {
            favorites = (dictionary["favorite_count"] as? Int) ?? 0
        }
    
        
        print(favorites)
        
        tweetID = dictionary["id_str"] as? String
        
        let timeString = dictionary["created_at"] as? String
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
        //set up date
        if let timeString = timeString {
            let timeTweeted = formatter.date(from: timeString) as Date?
            let timeString = "\(timeTweeted!)"
            let endIndex = timeString.index(timeString.startIndex, offsetBy:10)
            dateTweeted = timeString.substring(to: endIndex)
            
        }
        
        //Access the tweeter and save as a User type.
        let user: User = User(dictionary: dictionary["user"] as! NSDictionary)
        tweeter = user
        handle = ("@" + "\(user.screenName!)")
        
        //Assess retweet and favorite state for image assets in table cell.
        let retweetState: Bool? = dictionary["retweeted"] as? Bool
        if (retweetState!) {
            isRetweeted = true;
        } else {
            isRetweeted = false;
        }
        
        let favoriteState: Bool? = dictionary["favorited"] as? Bool
        if (favoriteState!) {
            isFavorited = true;
        } else {
            isFavorited = false;
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet: Tweet = Tweet(dictionary: dictionary)
            print(dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }

}
