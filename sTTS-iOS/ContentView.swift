//
//  ContentView.swift
//  sTTS-iOS
//
//  Created by Ethel Arterberry on 9/16/23.
//

import SwiftUI
import AVFoundation

struct Voice: Hashable {
    var voice: AVSpeechSynthesisVoice
    var text: String
}

struct ContentView: View {
    @State var textIn: String = ""
    @State var voiceSelect: Voice?
    @State var speed: Float = AVSpeechUtteranceDefaultSpeechRate
    @State var volume: Float = 0.8
    @State var pitch: Float = 0.8
    
    var voices: [Voice] = []
    
    init() {
        let speechVoices = AVSpeechSynthesisVoice.speechVoices();
        let currentLocale = AVSpeechSynthesisVoice.currentLanguageCode()
        
        for speechVoice in speechVoices {
            if (currentLocale == speechVoice.language) {
                let voice = Voice(
                    voice: speechVoice,
                    text: "\(speechVoice.name) (\(speechVoice.language))"
                );
                voices.append(voice)
            }
        }
    }
    
    var body: some View {
        VStack() {
            Text("sTTS").font(.largeTitle).bold()
            HStack() {
                Text("version 0.1")
                Spacer()
                Text("Sept 16, 2023").italic()
            }.padding(.top, -3.0).padding([.leading, .bottom, .trailing]).padding(.horizontal)
            Form() {
                VStack() {
                    // Text field
                    TextField("Text to be spoken",
                                text: $textIn,
                                axis: .vertical)
                    .lineLimit(15, reservesSpace: true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Voice picker
                    Picker("Voice", selection: $voiceSelect) {
                        ForEach (voices, id: \.self) { voice in
                            Text("\(voice.text)").tag(voice as Voice?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: voiceSelect) {
                        voiceSelect = $0
                    }.padding(.top)
                    
                    // Volume slider
                    HStack(alignment: .center) {
                        Text("Volume")
                            .padding(.bottom)
                        
                        Slider(
                                value: $volume,
                                in: 0.0...1.0)
                        {
                            Text("Volume")
                        }
                        .padding([.leading, .bottom, .trailing])
                        
                        Text(NSString(format: "%.2f", volume) as String)
                            .padding(.bottom)
                            
                    }
                    
                    // Speed slider
                    HStack(alignment: .center) {
                        Text("Speed")
                            .padding(.bottom)
                        
                        Slider(
                                value: $speed,
                                in: AVSpeechUtteranceMinimumSpeechRate...AVSpeechUtteranceMaximumSpeechRate)
                        {
                            Text("Speed")
                        }
                        .padding([.leading, .bottom, .trailing])
                        
                        Text("\(NSString(format: "%.2f", speed))x")
                            .padding(.bottom)
                            
                    }
                    .padding(.top, -13.0)
                    
                    // Pitch slider
                    HStack(alignment: .center) {
                        Text("Pitch")
                            .padding(.bottom)
                        
                        Slider(
                                value: $pitch,
                                in: 0.5...5.5)
                        {
                            Text("Pitch")
                        }
                        .padding([.leading, .bottom, .trailing])
                        
                        Text("\(NSString(format: "%.2f", pitch))x")
                            .padding(.bottom)
                            
                    }
                    .padding(.top, -13.0)
                    
                    // Speak button
                    Button(action: speak) {
                        Text("Speak")
                    }
                    .padding(.top)
                    .buttonStyle(BorderedButtonStyle())
                }.padding()
            }
        }
        
    }
    
    func speak() {
        let voice = voiceSelect?.voice
        
        if (voice != nil) {
            let utterance = AVSpeechUtterance(string: textIn)
            
            utterance.rate = speed
            utterance.pitchMultiplier = pitch
            utterance.postUtteranceDelay = 0.2
            utterance.volume = volume
            
            utterance.voice = voice
            
            let synth = AVSpeechSynthesizer()
            synth.speak(utterance)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
