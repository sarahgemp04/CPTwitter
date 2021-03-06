//
//  User.swift
//  TwitterDemo
//
//  Created by Sarah Gemperle on 2/5/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit

class User: NSObject {

    static let didLogOutNotification = "UserLoggedOut"
    var name: NSString?
    var screenName: NSString?
    var profileURL: URL?
    var tagline: NSString?
    var userID: String!
    var banner: URL?
    var location: String?
    var followers: Int = 0
    var following: Int = 0
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        self.name = dictionary["name"] as? NSString
        self.screenName = dictionary["screen_name"] as? NSString
        let url: URL? = URL(string: "\(dictionary["profile_image_url"]!)")
        
        if let url = url {
            self.profileURL = url
        }
        
        self.tagline = dictionary["description"] as? NSString
        self.userID = dictionary["id_str"] as! String
        let banner = dictionary["profile_banner_url"] as? String
        if let banner = banner {
            let bannerURL = URL.init(string: banner )
            self.banner = bannerURL
             print(bannerURL!)
        }
       
        self.location = dictionary["location"] as? String
        self.followers = dictionary["followers_count"] as! Int
        self.following = dictionary["friends_count"] as! Int
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
           
            if _currentUser == nil {
                return nil
            }
            let defaults = UserDefaults.standard
            let userData = defaults.object(forKey: "currentUserData") as? Data
            if let userData = userData {
                    print(userData)

                    let dict = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dict)
                
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
            
                defaults.set(data, forKey: "currentUserData")
                defaults.synchronize()
            } else {
                defaults.set(nil, forKey: "currentUserData")
                defaults.synchronize()
            }
        }
    }
    
}
