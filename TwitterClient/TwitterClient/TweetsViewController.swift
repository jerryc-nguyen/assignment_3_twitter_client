//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Welcome on 7/23/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit

let DetailsSegueName = "detailsSegue"
let NewTweetSegueName = "newTweetSegue"

class TweetsViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets = [Tweet]()
    
    let client = TwitterAPIClient.sharedInstance
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.delaysContentTouches = false
        
        refreshControl.addTarget(self, action: #selector(loadTweets), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        loadTweets()
    }
    
    func loadTweets() {
        client.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }) { (error: NSError) in
            print("Error: ", error.localizedDescription)
        }
    }
    
    func registerNibs() {
        tableView.registerNib(UINib(nibName: TweetItemTableViewCell.ClassName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: TweetItemTableViewCell.ClassName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogoutClicked(sender: AnyObject) {
        TwitterAPIClient.sharedInstance.logout()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == NewTweetSegueName {
            let composeVC = segue.destinationViewController as! ComposeTweetViewController
            composeVC.delegate = self
        }
    }

}

extension TweetsViewController: TweetItemTableViewCellDelegate {
    
    func tweetItemTableViewCellDelegate(tweetItemTableViewCell: TweetItemTableViewCell, triggeredAction value: Int) {
        
        let indexPath = tableView.indexPathForCell(tweetItemTableViewCell)
        let selectedTweet = tweets[indexPath!.row]
        
        switch (value) {
        case TweetActionTypes.Reply.rawValue:
            let composeVC = ComposeTweetViewController.initFromStoryBoard()
            composeVC.isReply = true
            composeVC.replyToStatusId = selectedTweet.uuid
            
            if let screenName = selectedTweet.user.screenName {
               composeVC.screenNameToReply = "@\(screenName)"
            }
            
            composeVC.delegate = self
            
            navigationController?.pushViewController(composeVC, animated: true)
        case TweetActionTypes.Retweet.rawValue:
            let isRetweet = !selectedTweet.retweeted
            
            client.retweet(selectedTweet.uuid!, isRetweet: isRetweet,  success: { (tweet: Tweet) in
                tweetItemTableViewCell.isRetweeted = tweet.retweeted
                tweetItemTableViewCell.refreshhHighLightBtn()
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
            })
            
        case TweetActionTypes.Favorite.rawValue:
            let isFavorite = !selectedTweet.favorited
            client.favorite(selectedTweet.uuid!, isFavorite: isFavorite, success: { (tweet: Tweet) in
                tweetItemTableViewCell.isFavorited = tweet.favorited
                tweetItemTableViewCell.refreshhHighLightBtn()
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
        default: break
        }
        
    }
}

extension TweetsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TweetItemTableViewCell.ClassName) as! TweetItemTableViewCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension TweetsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVC = DetailsViewController.initFromStoryBoard()
        detailVC.tweet = tweets[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension TweetsViewController: ComposeTweetViewControllerDelegate {
    func composeTweetViewControllerDelegate(composeTweetViewController: ComposeTweetViewController, createdTweet value: Tweet) {
        tweets.insert(value, atIndex: 0)
        tableView.reloadData()
    }
}

