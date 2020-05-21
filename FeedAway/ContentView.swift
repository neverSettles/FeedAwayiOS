//
//  ContentView.swift
//  FeedAway
//
//  Created by Christopher Settles on 4/24/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import SwiftUI
import SafariServices
//import BlockerManager

struct ContentView: View {
    @State private var facebook = false
    
    var body: some View {
        VStack {
            Text("Feed Away!")
            
            HStack {
                Image("facebook").resizable()
                .frame(width: 32.0, height: 32.0)
                Button(action: {
                    self.facebook.toggle()
                    NSLog("Making call to reloadBlocker()")
                    BlockerManager().reloadBlocker()
                }) {
                    Text("Reload Content Blocker")
                }
            }
            if facebook {
                Text("Facebook Blocked!")
                    .font(.largeTitle)
            }
            if BlockerManager().appIsInstalled(appName: "fb://") {
                Text("You need to uninstall facebook")
            } else {
                Text("You uninstalled facebook! ")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
