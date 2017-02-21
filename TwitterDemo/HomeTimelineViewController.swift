//
//  HomeTimelineViewController.swift
//  TwitterDemo
//
//  Created by Sarah Gemperle on 2/6/17.
//  Copyright © 2017 Sarah Gemperle. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]?
    
    @IBOutlet weak var composeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var profTapRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        ProfileViewController.currUser = User.currentUser!
        TwitterClient.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            for tweet in tweets {
                print(tweet.tweetText!)
            }
        }) { (error: Error) in
            print("homeTimeline error: \(error.localizedDescription)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //User tapped logout button
    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance!.logout()
    }
    
    //Set up each row of table view with tweet info.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TableViewCell
        cell.tweet = tweets![indexPath.row]
        cell.setup()
        
        
        return cell
    }
    
    
    @IBAction func profileIconTapped(_ sender: AnyObject) {
        ProfileViewController.currUser = User.currentUser!
        performSegue(withIdentifier: "ProfileSegue", sender: self)
    }

    
    
    //Determine number of tweets - set table View numRows equal to this.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    //Pass over tweet details to tweetDetails View Controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as? TableViewCell
        
        if let cell = cell {
            let tweet = cell.tweet
            let destination = segue.destination as! tweetsDetailsViewController
            destination.tweet = tweet
        }
        
    }
    
    
   
}
