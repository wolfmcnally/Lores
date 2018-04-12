//
//  Sound.swift
//  Pods
//
//  Created by Wolf McNally on 4/7/18.
//

import Foundation
import AVFoundation
//import AudioKit1

public class Sound {
    private let asset: NSDataAsset
    private let player: AVAudioPlayer

    public init(name: String) {
        #if os(macOS)
        asset = NSDataAsset(name: NSDataAsset.Name(rawValue: name))!
        #else
        asset = NSDataAsset(name: name)!
        #endif
        do {
            player = try AVAudioPlayer(data:asset.data, fileTypeHint: nil)
            player.prepareToPlay()
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }

    public func play() {
        if player.isPlaying {
            player.currentTime = 0
        } else {
            player.play()
        }
    }

//    public static func beep() {
//        do {
//            let oscillator = AKOscillator()
//            AudioKit.output = oscillator
//            try AudioKit.start()
//            oscillator.start()
//        } catch {
//            print(error)
//        }
//    }
}
