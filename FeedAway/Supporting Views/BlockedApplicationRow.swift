//
//  BlockedApplicationRow.swift
//  FeedAway
//
//  Created by Christopher Settles on 9/17/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import SwiftUI

struct BlockedApplicationRow: View {
    let application: Application
    let userSelections: UserSelections
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    if application.appInstalled {
                        Text("You should uninstall the " + application.displayName + " app first!")
                    } else {
                        Text("Good job, " + application.displayName + " is uninstalled!")
                    }
                }.multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true)
                HStack {
                    Image(application.resourceName).resizable().frame(width: 32.0, height: 32.0)
                    Button(action: {
                        self.application.blockedChecked.toggle()
                        BlockerManager().reloadBlocker(userSelections: self.userSelections)
                        UserDefaults.standard.set(self.application.blockedChecked, forKey: self.application.userDefaultsURL)}){
                            Toggle(isOn: application.$blockedChecked) {
                                Text(application.displayName + " Feed Blocker")
                            }
                        }
                }.padding().disabled(application.appInstalled)
            if application.blockedChecked {
                Text(application.displayName + " feed is being blocked on Safari.")
            }
            }.padding()
                .overlay(RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.gray, lineWidth: 4)
            )
        }.padding(.bottom, 20.0)
    }
}

// TODO: Fix Preview
//struct BlockedApplicationRow_Previews: PreviewProvider {
//    static var previews: some View {
//        BlockedApplicationRow(
//            application: Application(displayName: "Facebook", resourceName: "facebook", userDefaultsURL: "facebookChecked",  appInstalled: BlockerManager().appIsInstalled(appName: "fb://"), blockedChecked: true),
//            userSelections: UserSelections(facebookChecked: true, youtubeChecked: true)
//        )
//    }
//}
