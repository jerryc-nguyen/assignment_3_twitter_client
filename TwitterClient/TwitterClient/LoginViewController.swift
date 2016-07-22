//
//  LoginViewController.swift
//  TwitterClient
//
//  Created by Welcome on 7/23/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginClicked(sender: AnyObject) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string: "https://api.twitter.com"),
                                                    consumerKey: "Yr5fqM7SRLMkv7ALlXCLUgPfE",
                                                    consumerSecret: "z4SYB31U6RNzSjbrJORDLcI54gaH5fxF72965eCaWE4G9YBuCq")
        twitterClient.deauthorize()
        twitterClient.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterclient://oauth"), scope: nil, success: { (response: BDBOAuth1Credential!) in
            print("I got token")
            let authorizeUrl = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token)")!
            UIApplication.sharedApplication().openURL(authorizeUrl)
        }) { (error: NSError!) in
            print("error", error.localizedDescription)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
