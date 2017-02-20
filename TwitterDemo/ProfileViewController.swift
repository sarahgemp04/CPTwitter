//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by Sarah Gemperle on 2/20/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    static var currUser: User?
    
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profImageView: UIImageView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        //Styling borders/corner radius etc
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 2
        
        profImageView.layer.cornerRadius = 7
        profImageView.layer.borderWidth = 5
        profImageView.layer.borderColor = UIColor.white.cgColor
        
        coverImageView.layer.borderWidth = 2
        coverImageView.layer.borderColor = UIColor.lightGray.cgColor
        
        if ProfileViewController.currUser?.profileURL != nil {
            self.profImageView.setImageWith(ProfileViewController.currUser!.profileURL!)
        }
        handleLabel.text = "@ + \(ProfileViewController.currUser!.screenName as! String)"
        
        nameLabel.text = ProfileViewController.currUser!.name as! String
        
        if ProfileViewController.currUser!.location != nil {
            locationLabel.text = ProfileViewController.currUser?.location!
        }
        
        followersLabel.text = "\(ProfileViewController.currUser!.followers)"
        followingLabel.text = "\(ProfileViewController.currUser!.following)"
        
        //Set cover image
        if ProfileViewController.currUser!.banner != nil {
            coverImageView.setImageWith(ProfileViewController.currUser!.banner!)
        }
        locationImageView.image = #imageLiteral(resourceName: "1487654234_location-24")
       
        loadUserTweets()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTweetCell") as! ProfileViewCell
        cell.tweet = tweets![indexPath.row]
        cell.setup()
        
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadUserTweets() {
        print(ProfileViewController.currUser!.userID)
        TwitterClient.sharedInstance!.getUserTweets(userID: ProfileViewController.currUser!.userID, success: { (tweets: [Tweet]) in
         
            self.tweets = tweets
            for tweet in self.tweets! {
                print(tweet)
            }
            self.tableView.reloadData()
            
        }) { (error: Error?) in
            print("error loading user profile tweets: " + "\(error!.localizedDescription)")
        }
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
