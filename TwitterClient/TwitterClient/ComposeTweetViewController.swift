//
//  ComposeTweetViewController.swift
//  TwitterClient
//
//  Created by Welcome on 7/23/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetText: UITextView!
    
    let client = TwitterAPIClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = User.currentUser {
            userImageView.setImageWithURL(user.profileImageUrl!)
            nameLabel.text = user.name
            screenNameLabel.text = user.screenName
        }
    }
    
    
    @IBAction func onCreateTweet(sender: AnyObject) {
        if let tweetText = tweetText.text {
            if tweetText.characters.count > 5 {
                client.createTweet(tweetText, success: { (tweet: Tweet) in
                    print("Create tweet success", tweet.text)
                }) { (error: NSError) in
                    print("Create tweet fail: ", error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func onCancelClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
