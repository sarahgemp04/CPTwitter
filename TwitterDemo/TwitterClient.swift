//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by Sarah Gemperle on 2/5/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com") as! URL, consumerKey: "caMNg97WsEFqfiOqZLSU5FmzE", consumerSecret: "Q5gk2YlVBKe2adyglGfvmOkOwUpnp3t9qUhAp1pZE9UkphsJNW")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error?) -> ())?
    
    
    func login(success: @escaping () -> (), failure: @escaping (Error?) -> () ) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance!.deauthorize()
        TwitterClient.sharedInstance!.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "mytwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            let url: URL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }, failure: { (error: Error?)  in
            self.loginFailure?(error)
        })
    }
    
    func logout() {
        User.currentUser = nil
        print(User.currentUser)
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.didLogOutNotification), object: nil)
    }
    
    func handleOpenURL(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.sharedInstance!.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                print(user.dictionary)
                self.loginSuccess?()
                        
            }, failure: { (error: Error?) in
                self.loginFailure?(error)
            })
            
        }) { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error?) -> ()) {
            TwitterClient.sharedInstance!.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (URLSessionDataTask, response: Any?) -> Void in
                    let userDictionary = response as? NSDictionary
                
                if let userDictionary = userDictionary {
                    let user: User = User(dictionary: userDictionary)
                    success(user)
                }
                
            }, failure: { (task: URLSessionDataTask?, error: Error) in
               print("currentAccount failure: \(error.localizedDescription)")
                failure(error)
        })
    }
    
    //For profile timeline, get the user's most recent tweets with their user id.
    func getUserTweets(userID: String, success: @escaping ([Tweet])->(), failure: @escaping (Error?) -> ()) {
        TwitterClient.sharedInstance!.get("1.1/statuses/user_timeline.json?user_id=\(userID)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?
            ) in
            let tweetsResponseDict: [NSDictionary] = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: tweetsResponseDict)
            success(tweets)
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("error loading user's tweets: \(error.localizedDescription)")
                
        })
    }
    
    func retweet(currTweet: Tweet, success: @escaping (Int)->(),  failure: @escaping (Error?) -> ()) {
        
print(currTweet.tweetID!)
           // let action: String = tweet.isRetweeted ? "unretweet" : "retweet"
            TwitterClient.sharedInstance!.post("1.1/statuses/retweet/\(currTweet.tweetID!).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                
                let retweetResponseDict: NSDictionary = response as! NSDictionary
                var newNumRetweets: Int = retweetResponseDict.value(forKeyPath: "retweet_count") as! Int
                //Since post function response may not immediately show updated retweet count (as stated in API docs), increment numRetweets.
                success(newNumRetweets)
                
                }, failure: { (task: URLSessionDataTask?, error: Error) in
                    print("Error retweeting: \(error)")
                    failure(error)
            })
    }
    
    func favorite(currTweet: Tweet, success: @escaping (Int)->(),  failure: @escaping (Error?) -> ()) {
        
        print(currTweet.tweetID!)
        // let action: String = tweet.isRetweeted ? "unretweet" : "retweet"
        
        TwitterClient.sharedInstance!.post("/1.1/favorites/create.json?id=\(currTweet.tweetID!)", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            let favResponseDict: NSDictionary = response as! NSDictionary
            let status = favResponseDict["retweeted_status"] as? NSDictionary
            var newNumFavs = 0
            if status != nil {
                newNumFavs  = (status!["favorite_count"] as? Int) ?? 0
            } else {
                newNumFavs = (favResponseDict["favorite_count"] as? Int) ?? 0
            }
            
            //Since post function response may not immediately show updated favorite count (as stated in API docs), increment numFavs.
            newNumFavs = newNumFavs + 1
            success(newNumFavs)
            
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print("Error favoriting: \(error)")
                failure(error)
        })
    }
    
    static func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
            sharedInstance!.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
                
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
    
    func tweet(tweet: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        
        var paramDict: [String: String] = [String: String]()
        paramDict.updateValue(tweet, forKey: "status")
        

        TwitterClient.sharedInstance!.post(
            "1.1/statuses/update.json", parameters: paramDict, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
                
                let responseDict: NSDictionary = response as! NSDictionary
                success(Tweet.init(dictionary: responseDict))
                
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error.localizedDescription)
        })
    }
    
}
