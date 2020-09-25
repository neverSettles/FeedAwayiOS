//
//  ShareSheetView.swift
//  FeedAway
//
//  Created by Christopher Settles on 9/24/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import SwiftUI

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
        let data = "Hey! I'm using FeedAway to "
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct ShareSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheetView()
    }
}
