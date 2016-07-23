//
//  User.swift
//  TwitterClient
//
//  Created by Welcome on 7/23/16.
//  Copyright © 2016 Nhan. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: NSURL?
    var tagline: String?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        let profileImageUrl = dictionary["profile_image_url_https"] as? String
        if let profileImageUrl = profileImageUrl {
            self.profileImageUrl = NSURL(string: profileImageUrl)
        }
        
        tagline = dictionary["description"] as? String
    }
}
