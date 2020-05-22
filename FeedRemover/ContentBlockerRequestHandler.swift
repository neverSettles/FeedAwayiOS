//
//  ContentBlockerRequestHandler.swift
//  FeedRemover
//
//  Created by Christopher Settles on 4/24/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        let file = "combinedRuleset.json"
        if let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.rulesetSharing") {
            let path     = dir.appendingPathComponent(file)
            let attachment =  NSItemProvider(contentsOf: path)!
            
            let item = NSExtensionItem()
            item.attachments = [attachment]
            context.completeRequest(returningItems: [item], completionHandler: nil)
        }
    }
}
