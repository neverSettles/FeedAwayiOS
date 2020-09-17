//
//  ContentView.swift
//  FeedAway
//
//  Created by Christopher Settles on 4/24/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import SwiftUI
import SafariServices

import UIKit
import AVKit
import AVFoundation


struct Application {
    let displayName: String
    let resourceName: String
    let userDefaultsURL: String
    let appInstalled: Bool
    @Binding var blockedChecked: Bool
}

struct ContentView: View {
    @ObservedObject var userSelections = UserSelections(facebookChecked: UserDefaults.standard.bool(forKey: "facebookChecked"), youtubeChecked: UserDefaults.standard.bool(forKey: "youtubeChecked"))
    
    // Need this to be an ObservableObject instance so that we can update the values outside of the view!
    @ObservedObject var extensionActivatedObject = ExtensionActivatedObject()
    
    var body: some View {
        VStack {
            if !extensionActivatedObject.extensionActivated  {
                Text("You're almost there!")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .lineLimit(0)
                    .padding(.bottom, 15.0)
                
                Text("Follow the instructions to enable FeedAway in settings then return here.")
                .multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true)
                VideoPlayer(videoFileName: "FeedAwayInstallShort", videoFileType: "mp4")
            }
            else {
                VStack {
                    Text("FeedAway!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .lineLimit(0)
                        .padding(.bottom, 15.0)
                    
                    Text("FeedAway Extension is activated in settings. Good job.")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 80.0)
                    
                    BlockedApplicationRow(
                        application: Application(displayName: "Facebook", resourceName: "facebook", userDefaultsURL: "facebookChecked",  appInstalled: BlockerManager().appIsInstalled(appName: "fb://"), blockedChecked: $userSelections.facebookChecked), userSelections: userSelections)
                    
                    BlockedApplicationRow(application: Application(displayName: "Youtube", resourceName: "youtube", userDefaultsURL: "youtubeChecked" , appInstalled: BlockerManager().appIsInstalled(appName: "youtube://"), blockedChecked: $userSelections.youtubeChecked), userSelections: userSelections)
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
