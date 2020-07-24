//
//  ContentView.swift
//  FeedAway
//
//  Created by Christopher Settles on 4/24/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import SwiftUI
import SafariServices
import AVFoundation

import UIKit
import AVKit
import AVFoundation


struct PlayerView: UIViewRepresentable {
  func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
  }
  func makeUIView(context: Context) -> UIView {
    return PlayerUIView(frame: .zero)
  }
}

class PlayerUIView: UIView {
    var player: AVPlayer!
    private let playerLayer = AVPlayerLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        guard let path = Bundle.main.path(forResource: "FeedAwayInstallShort", ofType:"mp4") else {
        debugPrint("FeedAwayInstallShort.mp4 not found")
        return
    }

    let player = AVPlayer(url: URL(fileURLWithPath: path))
    player.play()
    self.player = player

    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [weak self] _ in
        self?.player?.seek(to: CMTime.zero)
        self?.player?.play()
    }
    
    playerLayer.player = player
    layer.addSublayer(playerLayer)
  }
  required init?(coder: NSCoder) {
   fatalError("init(coder:) has not been implemented")
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    playerLayer.frame = bounds
  }
}

struct ApplicationBlockerRow: View {
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
            Text("Feed Away!")
                .font(.title)
                .multilineTextAlignment(.center)
                .lineLimit(0)
                .padding(.bottom, 15.0)
                
            
            if !extensionActivatedObject.extensionActivated  {
                Text("Follow the instructions to enable FeedAway in settings then return here.")
                .multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true)
                PlayerView()
            }
            else {
                Text("FeedAway Extension is activated in settings. Good job.")
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 80.0)
                
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
