//
//  VideoPlayer.swift
//  FeedAway
//
//  Created by Christopher Settles on 9/17/20.
//  Copyright © 2020 Christopher Settles. All rights reserved.
//

import SwiftUI
import AVFoundation

struct VideoPlayer: UIViewRepresentable {
    let videoFileName: String
    let videoFileType: String
  func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<VideoPlayer>) {
  }
  func makeUIView(context: Context) -> UIView {
    return VideoPlayerUIView(frame: .zero, videoFileName: videoFileName, videoFileType: videoFileType)
  }
}

class VideoPlayerUIView: UIView {
    var player: AVPlayer!
    private let playerLayer = AVPlayerLayer()
    
    init(frame: CGRect, videoFileName: String, videoFileType: String) {
        super.init(frame: frame)
        guard let path = Bundle.main.path(forResource: videoFileName, ofType:videoFileType) else {
        debugPrint(videoFileName + "." + videoFileType + " not found")
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
