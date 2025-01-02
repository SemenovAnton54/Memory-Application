//
//  SpeechUtteranceService.swift
//  Memory
//

import AVFoundation

class SpeechUtteranceService: SpeechUtteranceServiceProtocol {
    private var speechSynthesizer = AVSpeechSynthesizer()
    private let audioSession = AVAudioSession()

    init() {
        do {
            try audioSession.setCategory(.playback, mode: .default, options: .mixWithOthers)
        } catch let error {
            print("Error: ", error.localizedDescription)
        }
    }

    func play(_ text: String) {
        speechSynthesizer.stopSpeaking(at: .immediate)

        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        speechSynthesizer.speak(speechUtterance)
    }
}
