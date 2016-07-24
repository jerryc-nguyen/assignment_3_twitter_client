//
//  DetailsViewController.swift
//  TwitterClient
//
//  Created by Welcome on 7/25/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit

let DetailsReplySegueName = "detailsReplySegue"

class DetailsViewController: UIViewController {
    
    var tweet: Tweet!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var retweetedCountLabel: UILabel!
    
    @IBOutlet weak var favoritedCountLabel: UILabel!
    
    @IBOutlet weak var retweetBtn: UIButton!
    
    @IBOutlet weak var favoritedBtn: UIButton!
    
    let client = TwitterAPIClient.sharedInstance
    
    var isRetweeted = false
    var isFavorited = false
    
    static func initFromStoryBoard() -> DetailsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier("DetailsViewController") as! DetailsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayDataToView()
        refreshhHighLightBtn()
        
        // Do any additional setup after loading the view.
    }
    
    func refreshhHighLightBtn() {
        if tweet?.favorited == true || isFavorited == true  {
            favoritedBtn.imageView!.image = UIImage(named: "liked")
        }
        
        if tweet?.retweeted == true || isRetweeted == true {
            retweetBtn.imageView!.image = UIImage(named: "retweeted")
        }
    }
    
    func displayDataToView() {
        let user = tweet.user
        profileImageView.setImageWithURL(user.profileImageUrl!)
        nameLabel.text = user.name
        screenNameLabel.text = "@\(user.screenName!)"
        tweetTextLabel.text = tweet.text
        createdAtLabel.text = tweet.formattedSortDate
        
        retweetedCountLabel.text = "\(tweet.retweetCount) retweets"
        favoritedCountLabel.text = "\(tweet.favoritesCount) favorites"
    }

    @IBAction func onRetweet(sender: AnyObject) {
        
        client.retweet(tweet.uuid!, success: { (tweet: Tweet) in
            self.isRetweeted = true
            self.refreshhHighLightBtn()
            self.retweetedCountLabel.text = "\(tweet.retweetCount) retweets"
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
        
    }
 
    @IBAction func onFavoriteTweet(sender: AnyObject) {
        
        client.favorite(tweet.uuid!, success: { (tweet: Tweet) in
            self.isFavorited = true
            self.refreshhHighLightBtn()
            self.favoritedCountLabel.text = "\(tweet.favoritesCount) favorites"
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == DetailsReplySegueName {
            let replyVC = segue.destinationViewController as! ComposeTweetViewController
            replyVC.isReply = true
            replyVC.replyToStatusId = tweet.uuid
            replyVC.screenNameToReply = "@\(tweet.user.screenName)"
        }
    }
    

}
