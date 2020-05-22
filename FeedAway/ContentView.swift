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
    @State private var facebookChecked = false
    @State private var youtubeChecked = false
    
    @State private var facebookInstalled = false
    @State private var youtubeInstalled = false
    
    var body: some View {
        VStack {
            Text("Feed Away!")
            
            if BlockerManager().extensionActivated()  {
                Text("The FeedAway Extension is not activated on Safari Settings yet. Please activate.")
            }
            else {
                Text("FeedAway Extension is activated! ")
            VStack {
                if BlockerManager().appIsInstalled(appName: "fb://") {
                    Text("You first need to uninstall Facebook")
                } else {
                    Text("Congrats, Facebook is uninstalled!")
                }
                
                HStack {
                    Image("facebook").resizable().frame(width: 32.0, height: 32.0)
                    Button(action: {
                        self.facebookChecked.toggle()
                        BlockerManager().reloadBlocker(facebookChecked: self.facebookChecked, youtubeChecked: self.youtubeChecked)
                    })
                    {
                        Toggle(isOn: self.$facebookChecked) {
                            Text("Enable Facebook Feed Blocker")
                        }
                    }
                }
                .padding()
                .disabled(BlockerManager().appIsInstalled(appName: "fb://"))
            }
            
            VStack {
                if BlockerManager().appIsInstalled(appName: "youtube://") {
                    Text("You first need to uninstall Youtube")
                } else {
                    Text("Congrats, Youtube is uninstalled!")
                }
                
                HStack {
                    Image("youtube").resizable().frame(width: 32, height: 26.0)
                    Button(action: {
                        self.youtubeChecked.toggle()
                        BlockerManager().reloadBlocker(facebookChecked: self.facebookChecked, youtubeChecked: self.youtubeChecked)
                    })
                    {
                        Toggle(isOn: self.$youtubeChecked) {
                            Text("Enable Youtube Feed Blocker")
                        }
                    }
                }
                .padding()
                .disabled(BlockerManager().appIsInstalled(appName: "youtube://"))
            }
            
        }
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
