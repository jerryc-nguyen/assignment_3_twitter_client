//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Welcome on 7/23/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import BDBOAuth1Manager
import UIKit

class TwitterAPIClient: BDBOAuth1SessionManager {
    static var sharedInstance = TwitterAPIClient( baseURL: NSURL(string: "https://api.twitter.com"),
                                                  consumerKey: "Yr5fqM7SRLMkv7ALlXCLUgPfE",
                                                  consumerSecret: "z4SYB31U6RNzSjbrJORDLcI54gaH5fxF72965eCaWE4G9YBuCq" )
    var onLoginSuccess: (() -> ())?
    var onLoginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        onLoginSuccess = success
        onLoginFailure = failure
        
        deauthorize()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterclient://oauth"), scope: nil, success: { (response: BDBOAuth1Credential!) in
            print("I got token")
            let authorizeUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token)")!
            UIApplication.sharedApplication().openURL(authorizeUrl)
        }) { (error: NSError!) in
            print("error", error.localizedDescription)
        }
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let tweetDictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(tweetDictionaries)
            
            success(tweets)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        })
    }
    
    func currentUser(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        })
    }
    
    func handleOutSideCallbackFrom(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (response: BDBOAuth1Credential!) in
            
            self.homeTimeline({ (tweets: [Tweet]) in
                print("Get tweets", tweets)
            }, failure: { (error: NSError) in
                print("Get error", error.localizedDescription)
            })
            
            self.currentUser({ (user: User) in
                print("Get user:", user)
            }, failure: { (error: NSError) in
                print("Get error", error.localizedDescription)
            })
            
            self.onLoginSuccess?()
            
        }) { (error: NSError!) in
            self.onLoginFailure?(error)
        }
    }
    
}