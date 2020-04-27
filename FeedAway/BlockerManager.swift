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
    func reloadBlocker() {
        SFContentBlockerManager.reloadContentBlocker(
            withIdentifier: "com.example.FeedAway.FeedRemover",
            completionHandler: { (maybeErr: Error?) -> Void in
            if let err = maybeErr {
                NSLog("Error reloading Content Blocker:")
                NSLog(err.localizedDescription)
            } else {
                NSLog("Finished reloading Content Blocker")
            }
        })
    }
}
