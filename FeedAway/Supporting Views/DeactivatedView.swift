//
//  DeactivatedView.swift
//  FeedAway
//
//  Created by Christopher Settles on 9/17/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import SwiftUI

struct DeactivatedView: View {
    var body: some View {
        Text("You're almost there!")
            .font(.title)
            .multilineTextAlignment(.center)
            .lineLimit(0)
            .padding(.bottom, 15.0)
        
        Text("Follow the instructions to enable FeedAway in settings then return here.")
        .multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true)
        VideoPlayer(videoFileName: "FeedAwayInstallShort", videoFileType: "mp4")
    }
}

struct DeactivatedView_Previews: PreviewProvider {
    static var previews: some View {
        DeactivatedView()
    }
}
