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

struct Constants {
    static let width: CGFloat = 100
    static let kExtensionIdentifier: String = "com.example.FeedAway.FeedRemover"
}

class BlockerManager {
    func appIsInstalled(appName:String) -> Bool {
        let canOpen = UIApplication.shared.canOpenURL(NSURL(string: appName)! as URL)
        return canOpen
    }
    
    func extensionActivated() -> Bool {
        var enabled = false;
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: Constants.kExtensionIdentifier, completionHandler: { (state, error) in
            if let error = error {
                // TODO: handle the error
                NSLog("Error collecting state of blocker: \(error).")
            }
            if let state = state {
                let contentBlockerIsEnabled = state.isEnabled
                // TODO: do something with this value
                enabled = contentBlockerIsEnabled
            }
        })
        return enabled
    }
    
    func reloadBlocker(facebookChecked:Bool, youtubeChecked:Bool) {
        writeCombinedJsonFile(facebookChecked:facebookChecked, youtubeChecked:youtubeChecked)
        SFContentBlockerManager.reloadContentBlocker(
            withIdentifier: Constants.kExtensionIdentifier,
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
    
    
    
    fileprivate func loadJsonIntoRules(_ allRules: inout [[String : [String : String]]], _ jsonFileName: String) {
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json"){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [[String : [String : String]]] {
                    allRules.append(contentsOf: jsonResult)
                }
                else {
                    NSLog("Malformed JSON")
                }
            } catch {
                NSLog("Unexpected error: \(error).")
            }
        } else {
            NSLog("Could not load file")
        }
    }
    
    func combineJsonFiles(facebookChecked:Bool, youtubeChecked:Bool) -> [[String : [String : String]]]  {
        var allRules: [[String : [String : String]]] = []
        
        if facebookChecked {
            loadJsonIntoRules(&allRules, "facebook")
        }
        if youtubeChecked {
            loadJsonIntoRules(&allRules, "youtube")
        }
        
        return allRules
    }
    
    func writeCombinedJsonFile(facebookChecked:Bool, youtubeChecked:Bool) {
        let dictionary = combineJsonFiles(facebookChecked:facebookChecked, youtubeChecked:youtubeChecked)
        
        let jsonData = try! JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted)

        //Convert back to string. Usually only do this for debugging

        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
            let file = "combinedRuleset.json"
            if let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.rulesetSharing") {
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
