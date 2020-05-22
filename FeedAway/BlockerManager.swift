//
//  BlockerManager.swift
//  FeedAway
//
//  Created by Christopher Settles on 4/26/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import Foundation
import SafariServices
import MobileCoreServices
import Foundation

class BlockerManager {
    func appIsInstalled(appName:String) -> Bool {
        let canOpen = UIApplication.shared.canOpenURL(NSURL(string: appName)! as URL)
        return canOpen
    }
    
    func reloadBlocker(facebookChecked:Bool, youtubeChecked:Bool) {
        writeJSON()
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
    
    func writeJSON() {
        let selector = "div[role=main]" // Dynamically Generated
        let dictionary = [[
            "action": [ "type": "css-display-none", "selector": selector ],
            "trigger": [ "url-filter": ".*" ]
            ]]
        let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)

        //Convert back to string. Usually only do this for debugging

        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
            let file = "conbo.json"
            if let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.1a") {
                let path     = dir.appendingPathComponent(file)
                do {
                    try JSONString.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                }
                catch {
                }
            }
        }
    }
}
