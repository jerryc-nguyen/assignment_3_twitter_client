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
    
    var isFavorited: Bool {
        get {
            return tweet.favorited
        }
        
        set(value) {
            tweet.favorited = value
        }
    }
    
    var isRetweeted: Bool {
        get {
            return tweet.retweeted
        }
        
        set(value) {
            tweet.retweeted = value
        }
    }
    
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
        guard tweet != nil else {
            return
        }
        
        if isFavorited == true {
            favoritedBtn.setImage(UIImage(named: "liked"), forState: .Normal)
        } else {
            favoritedBtn.setImage(UIImage(named: "like-action"), forState: .Normal)
        }
        
        if isRetweeted == true {
            retweetBtn.setImage(UIImage(named: "retweeted"), forState: .Normal)
        } else {
            retweetBtn.setImage(UIImage(named: "retweet-action"), forState: .Normal)
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
        
        client.retweet(tweet.uuid!, isRetweet: !isRetweeted, success: { (tweet: Tweet) in
            self.isRetweeted = tweet.retweeted
            self.refreshhHighLightBtn()
            self.retweetedCountLabel.text = "\(tweet.retweetCount) retweets"
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
        
    }
 
    @IBAction func onFavoriteTweet(sender: AnyObject) {
        
        client.favorite(tweet.uuid!, isFavorite: !isFavorited, success: { (tweet: Tweet) in
            self.isFavorited = tweet.favorited
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
            
            if let screenName = tweet.user.screenName {
                replyVC.screenNameToReply = "@\(screenName)"
            }
            
        }
    }
    

}
