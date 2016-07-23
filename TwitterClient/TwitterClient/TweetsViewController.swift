//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Welcome on 7/23/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets = [Tweet]()
    
    let client = TwitterAPIClient.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibs()
        
        tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        
        client.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) in
            print("Error: ", error.localizedDescription)
        }
    }
    
    
    func registerNibs() {
        tableView.registerNib(UINib(nibName: TweetTableViewCell.ClassName, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: TweetTableViewCell.ClassName)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogoutClicked(sender: AnyObject) {
        TwitterAPIClient.sharedInstance.logout()
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

extension TweetsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TweetTableViewCell.ClassName) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}
