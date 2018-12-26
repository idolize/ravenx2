//
//  TextToSpeech.swift
//  RavenX2
//
//  Created by David Idol on 12/26/18.
//  Copyright © 2018 David Idol. All rights reserved.
//


#if os(OSX)
import AppKit
typealias SpeechSynthesizer = NSSpeechSynthesizer
#else
import AVFoundation
typealias SpeechSynthesizer = AVSpeechSynthesizer
#endif


class TextToSpeech {
    let synthesizer: SpeechSynthesizer
    
    init() {
        #if os(iOS)
        synthesizer = AVSpeechSynthesizer()
        #endif
        #if os(OSX)
        synthesizer = NSSpeechSynthesizer()
        #endif
    }

    func say(_ text: String) {
        #if os(iOS)
        let utterance = AVSpeechUtterance(string: text)
        synthesizer.speak(utterance)
        #endif
        #if os(OSX)
        synthesizer.startSpeaking(text)
        #endif
    }
}
