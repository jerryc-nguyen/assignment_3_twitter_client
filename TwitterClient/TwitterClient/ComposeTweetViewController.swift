//
//  ComposeTweetViewController.swift
//  TwitterClient
//
//  Created by Welcome on 7/23/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit

@objc protocol ComposeTweetViewControllerDelegate {
    optional func composeTweetViewControllerDelegate(composeTweetViewController: ComposeTweetViewController, createdTweet value: Tweet)
}

class ComposeTweetViewController: UIViewController {
    
    @IBOutlet weak var createTweetBtn: UIButton!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var tweetText: UITextView!
    
    
    var isReply: Bool = false
    var replyToStatusId: String?
    var screenNameToReply: String?
    
    static func initFromStoryBoard() -> ComposeTweetViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier("ComposeTweetViewController") as! ComposeTweetViewController
    }
    
    weak var delegate: ComposeTweetViewControllerDelegate?
    
    let client = TwitterAPIClient.sharedInstance
    
    let wordCountLabel = UILabel(frame: CGRectMake(0, 0, 30, 30))
    
    let limitCharsCount = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetText.delegate = self
        
        initViewComponent()
        customRightNavItems()
    
    }
    
    func initViewComponent() {
        
        if let user = User.currentUser {
            
            userImageView.setImageWithURL(user.profileImageUrl!)
            nameLabel.text = user.name
            screenNameLabel.text = user.screenName
        
            if isReply {
                if let screenNameToReply = screenNameToReply {
                    tweetText.text = screenNameToReply
                }
            }
        }
    }
    
    func customRightNavItems() {
        wordCountLabel.text = "\(limitCharsCount)"
        wordCountLabel.textColor = UIColor.lightGrayColor()
        let buttonTitle = isReply ? "Reply" : "Tweet"
        let saveButton = UIBarButtonItem(title: buttonTitle, style: .Plain, target: self, action: #selector(createTweet) )
        
        let wordCountRemainItem = UIBarButtonItem(customView: self.wordCountLabel)
        
        navigationItem.rightBarButtonItems = [saveButton, wordCountRemainItem]
    }
    
    func createTweet() {
        if let tweetText = tweetText.text {
            if tweetText.characters.count > 0 {
                
                var params = ["status": tweetText]
                
                if isReply {
                    params["in_reply_to_status_id"] = replyToStatusId
                }
                
                client.createTweet(params, success: { (tweet: Tweet) in
                    self.backToPreviousVC()
                    self.delegate?.composeTweetViewControllerDelegate?(self, createdTweet: tweet)
                }) { (error: NSError) in
                    print("Create tweet fail: ", error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func onCreateTweet(sender: AnyObject) {
        createTweet()
    }
    
    @IBAction func onCancelClicked(sender: AnyObject) {
        backToPreviousVC()
    }
    
    func backToPreviousVC() {
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

extension ComposeTweetViewController: UITextViewDelegate {
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let currentTextCount = textView.text.characters.count
        let remainingTextCount = limitCharsCount - currentTextCount
        wordCountLabel.text = "\(remainingTextCount)"
        
        return remainingTextCount > 0 || text.characters.count == 0
    }
    
}
