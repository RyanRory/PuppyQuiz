//
//  SoundManager.swift
//  PuppyQuiz
//
//  Created by Ryan ZHAO on 4/9/2025.
//

import AVFoundation

@MainActor
final class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    func preload() {
        // Do file IO off the main thread, then bind player on main
        Task.detached(priority: .utility) {
            guard let url = Bundle.main.url(forResource: "tiny_bark", withExtension: "flac"),
                  let data = try? Data(contentsOf: url) else { return }
            await MainActor.run {
                do {
                    self.player = try AVAudioPlayer(data: data)
                    self.player?.prepareToPlay()
                } catch {
                    print("AVAudioPlayer init error: \(error)")
                }
            }
        }
    }

    func playCorrectBark() {
        player?.currentTime = 0
        player?.play()
    }
}
