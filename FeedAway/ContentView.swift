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

struct ApplicationBlockerRow: View {
    let application: Application
    
    let userSelections: UserSelections
    
    var body: some View {
        VStack {
            if application.appInstalled {
                Text("You first need to uninstall " + application.displayName)
            } else {
                Text("Congrats, " + application.displayName + " is uninstalled!")
            }
            
            HStack {
                Image(application.resourceName).resizable().frame(width: 32.0, height: 32.0)
                Button(action: {
                    self.application.blockedChecked.toggle()
                    BlockerManager().reloadBlocker(userSelections: self.userSelections)
                    UserDefaults.standard.set(self.application.blockedChecked, forKey: self.application.userDefaultsURL)
                })
                {
                    Toggle(isOn: application.$blockedChecked) {
                        Text("Enable " + application.displayName + " Feed Blocker")
                    }
                }
            }
            .padding()
            .disabled(application.appInstalled)
        }
    }
}

struct Application {
    let displayName: String
    let resourceName: String
    let userDefaultsURL: String
    let appInstalled: Bool
    @Binding var blockedChecked: Bool
}

struct ContentView: View {
    @State var userSelections = UserSelections(facebookChecked: UserDefaults.standard.bool(forKey: "facebookChecked"), youtubeChecked: UserDefaults.standard.bool(forKey: "youtubeChecked"))
    
    // Need this to be an ObservableObject instance so that we can update the values outside of the view! 
    @ObservedObject var extensionActivatedObject = ExtensionActivatedObject()
    
    var body: some View {
        VStack {
            Text("Feed Away!")
            
            if !extensionActivatedObject.extensionActivated  {
                Text("The FeedAway Extension is not activated on Safari Settings yet. Please activate.")
            }
            else {
                Text("FeedAway Extension is activated! ")
                
                ApplicationBlockerRow(
                    application: Application(displayName: "Facebook", resourceName: "facebook", userDefaultsURL: "facebookChecked",  appInstalled: BlockerManager().appIsInstalled(appName: "fb://"), blockedChecked: $userSelections.facebookChecked), userSelections: userSelections
                )
                
                ApplicationBlockerRow(application: Application(displayName: "Youtube", resourceName: "youtube", userDefaultsURL: "youtubeChecked" , appInstalled: BlockerManager().appIsInstalled(appName: "youtube://"), blockedChecked: $userSelections.youtubeChecked), userSelections: userSelections)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
