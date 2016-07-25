//
//  TweetItemTableViewCell.swift
//  TwitterClient
//
//  Created by Welcome on 7/24/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit

enum TweetActionTypes: Int {
    case Reply = 0, Retweet, Favorite
}


@objc protocol TweetItemTableViewCellDelegate {
    optional func tweetItemTableViewCellDelegate(tweetItemTableViewCell: TweetItemTableViewCell, triggeredAction value: Int)
}


class TweetItemTableViewCell: UITableViewCell {
    
    static var ClassName: String = "TweetItemTableViewCell"
    
    weak var delegate: TweetItemTableViewCellDelegate?
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var retweetBtn: UIButton!
    
    @IBOutlet weak var favoritedBtn: UIButton!
    
    var tweet: Tweet! {
        didSet {
            let user = tweet!.user
            profileImageView.setImageWithURL(user.profileImageUrl!)
            nameLabel.text = user.name
            screenNameLabel.text = "@\(user.screenName!)"
            tweetTextLabel.text = tweet!.text
            createdAtLabel.text = "12"
            
            refreshhHighLightBtn()
        }
    }
    
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
    
    func toggleRetweeted() {
        tweet.favorited = !tweet.favorited
    }
    
    func toggleFavorited() {
        tweet.retweeted = !tweet.retweeted
    }
    
    @IBAction func onReplyTweet(sender: AnyObject) {
        self.delegate?.tweetItemTableViewCellDelegate?(self, triggeredAction: TweetActionTypes.Reply.rawValue)
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        self.delegate?.tweetItemTableViewCellDelegate?(self, triggeredAction: TweetActionTypes.Retweet.rawValue)
    }
    
    @IBAction func onFavoriteTweet(sender: AnyObject) {
        self.delegate?.tweetItemTableViewCellDelegate?(self, triggeredAction: TweetActionTypes.Favorite.rawValue)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        refreshhHighLightBtn()
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
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = UITableViewCellSelectionStyle.None
        // Configure the view for the selected state
    }
    
}
