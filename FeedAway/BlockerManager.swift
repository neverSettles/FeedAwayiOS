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
    static let kExtensionIdentifier: String = "com.chrissettles.FeedAway.FeedRemover"
}

class BlockerManager {
    func appIsInstalled(appName:String) -> Bool {
        let canOpen = UIApplication.shared.canOpenURL(NSURL(string: appName)! as URL)
        return canOpen
    }
    
    enum ActivationResult {
        case activated(Bool), failure(Error)
    }
    
    func extensionActivated(completion: @escaping (ActivationResult) -> ()) {
        // TODO : always true even when not activated. 
        SFContentBlockerManager.getStateOfContentBlocker(withIdentifier: Constants.kExtensionIdentifier, completionHandler: { (state, error) in
            if error != nil {
                    completion(.failure(error!))
                } else {
                    completion(.activated(state!.isEnabled))
                }
            })
    }
    
    func reloadBlocker(userSelections: UserSelections) {
        writeCombinedJsonFile(userSelections: userSelections)
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
            NSLog("Could not load file: " + jsonFileName)
        }
    }
    
    func combineJsonFiles(userSelections: UserSelections) -> [[String : [String : String]]]  {
        var allRules: [[String : [String : String]]] = []
        
        loadJsonIntoRules(&allRules, "trivialBase")
        
        if userSelections.facebookChecked {
            loadJsonIntoRules(&allRules, "facebook")
        }
        if userSelections.youtubeChecked {
            loadJsonIntoRules(&allRules, "youtube")
        }
        
        return allRules
    }
    
    func writeCombinedJsonFile(userSelections: UserSelections) {
        let dictionary = combineJsonFiles(userSelections: userSelections)
        
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
