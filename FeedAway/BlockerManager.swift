//
//  BlockerManager.swift
//  FeedAway
//
//  Created by Christopher Settles on 4/26/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import Foundation
import SafariServices

class BlockerManager {
    func appIsInstalled(appName:String) -> Bool {
        return UIApplication.shared.canOpenURL(NSURL(string: appName)! as URL)
    }
    
    func reloadBlocker() {
        SFContentBlockerManager.reloadContentBlocker(
            withIdentifier: "com.example.FeedAway.FeedRemover",
            completionHandler: { (maybeErr: Error?) -> Void in
            if let err = maybeErr {
                NSLog("Error reloading Content Blocker:")
                NSLog(err.localizedDescription)
            } else {
                NSLog("Finished reloading Content Blocker")
                // This will pass even if the user has not given Safari Content Blocking Permissions.
            }
        })
    }
}
