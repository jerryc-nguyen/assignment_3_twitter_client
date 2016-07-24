//
//  Tweet.swift
//  TwitterClient
//
//  Created by Welcome on 7/23/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var uuid: String?
    var user: User!
    var retweeted: Bool = false
    var favorited: Bool = false
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
        if let uuidStr = dictionary["id_str"] as? String {
            uuid = uuidStr
        }
        
        if let retweeted = dictionary["retweeted"] as? Bool {
            self.retweeted = retweeted
        }
        
        if let favorited = dictionary["favorited"] as? Bool {
            self.favorited = favorited
        }
        
        if let userDictionary = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userDictionary)
        }
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
}
