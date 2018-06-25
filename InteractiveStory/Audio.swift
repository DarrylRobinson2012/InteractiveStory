//
//  Audio.swift
//  InteractiveStory
//
//  Created by Darryl Robinson  on 3/9/18.
//  Copyright © 2018 Darryl Robinson . All rights reserved.
//

import Foundation
import AudioToolbox

extension Story {
    var soundEffectName: String {
        switch self {
        case .droid, .home: return "HappyEnding"
        case .monster: return "Ominous"
        default: return "PageTurn"
        }
    }
    var soundEffectUrl: URL {
        let path = Bundle.main.path(forResource: soundEffectName, ofType: "wav")!
        return URL(fileURLWithPath: path)
        
    }
}


class SoundEffectsPlayer {
    var sound: SystemSoundID = 0
    
    func playSound(for story: Story) {
        let soundUrl = story.soundEffectUrl as CFURL
        AudioServicesCreateSystemSoundID(soundUrl, &sound)
        AudioServicesPlaySystemSound(sound)
    }
    
}





