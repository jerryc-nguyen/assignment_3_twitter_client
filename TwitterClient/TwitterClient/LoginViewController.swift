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
    
    let loginSegueName:String = "loginSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginClicked(sender: AnyObject) {
        let client = TwitterAPIClient.sharedInstance
        client.login({ () in
            self.performSegueWithIdentifier(self.loginSegueName, sender: self)
        }) { (error: NSError) in
            print("Logged failure")
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
