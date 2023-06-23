//
//  PlaySound.swift
//  SlotApp
//
//  Created by Bulut Sistem on 23.06.2023.
//

import SwiftUI
import AVFoundation



var audioPlayer : AVAudioPlayer?

func playSound(sound:String,type:String){
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        }catch{
            print("failed to play")
        }
    }
}
