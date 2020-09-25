//
//  ActivatedView.swift
//  FeedAway
//
//  Created by Christopher Settles on 9/17/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import SwiftUI

struct Application {
    let displayName: String
    let resourceName: String
    let userDefaultsURL: String
    let appInstalled: Bool
    @Binding var blockedChecked: Bool
}

struct ActivatedView: View {
    @ObservedObject var userSelections = UserSelections(facebookChecked: UserDefaults.standard.bool(forKey: "facebookChecked"), youtubeChecked: UserDefaults.standard.bool(forKey: "youtubeChecked"))
    
    var body: some View {
        VStack {
            Text("FeedAway!")
                .font(.title)
                .multilineTextAlignment(.center)
                .lineLimit(0)
                .padding(.bottom, 15.0)
            
            Text("FeedAway Extension is activated in settings. Good job.")
                .multilineTextAlignment(.center)
                .padding(.bottom, 80.0)
            
            ShareSheetView()
            
            BlockedApplicationRow(
                application: Application(displayName: "Facebook", resourceName: "facebook", userDefaultsURL: "facebookChecked",  appInstalled: BlockerManager().appIsInstalled(appName: "fb://"), blockedChecked: $userSelections.facebookChecked), userSelections: userSelections)
            
            BlockedApplicationRow(application: Application(displayName: "Youtube", resourceName: "youtube", userDefaultsURL: "youtubeChecked" , appInstalled: BlockerManager().appIsInstalled(appName: "youtube://"), blockedChecked: $userSelections.youtubeChecked), userSelections: userSelections)
        }
    }
}

struct ActivatedView_Previews: PreviewProvider {
    static var previews: some View {
        ActivatedView()
    }
}
