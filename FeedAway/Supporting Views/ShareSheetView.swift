//
//  ShareSheetView.swift
//  FeedAway
//
//  Created by Christopher Settles on 9/24/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import SwiftUI

let appURL = "https://apps.apple.com/app/id1524223732"
let shareMessage = "I'm using FeedAway to remove the facebook and youtube news feeds when using them on Safari. You should try it out too. Here's a link to download: " + appURL

struct ShareSheetView: View {
    var body: some View {
        Button(action: actionSheet) {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
        }
    }
    
    func actionSheet() {
        
        let av = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct ShareSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheetView()
    }
}
