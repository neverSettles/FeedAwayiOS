//
//  UserData.swift
//  FeedAway
//
//  Created by Christopher Settles on 5/22/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import SwiftUI
import Combine

final class UserSelections: ObservableObject  {
    @Published var facebookChecked = false
    @Published var youtubeChecked = false
    
    init() {
        self.facebookChecked = false
        self.youtubeChecked = false
    }
    init(facebookChecked: Bool, youtubeChecked: Bool) {
        self.facebookChecked = facebookChecked
        self.youtubeChecked = youtubeChecked
    }
}

final class ExtensionActivatedObject: ObservableObject  {
    @Published var extensionActivated = false
}
