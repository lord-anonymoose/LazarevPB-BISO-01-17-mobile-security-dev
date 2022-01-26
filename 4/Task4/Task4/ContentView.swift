//
//  ContentView.swift
//  Task4
//
//  Created by Philipp on 26.01.2022.
//

import SwiftUI
import Combine
import AVFoundation


struct ContentView: View {
    
    // First subtask
    @State private var classes = ""
    @State private var days = ""
    @State private var avg = 0
    
    // Second subtask
    @State private var age = ""
    
    // Third subtask
    @State private var string = ""
    @State private var shuffledString = ""
    
    // Fourth subtask
    var player: AVAudioPlayer?

    func playSound() {
        guard let soundFileURL = Bundle.main.url(
                forResource: "glowingReview",
                withExtension: "mp3"
            ) else {
                return
            }
            
            do {
                // Configure and activate the AVAudioSession
                try AVAudioSession.sharedInstance().setCategory(
                    AVAudioSession.Category.playback
                )

                try AVAudioSession.sharedInstance().setActive(true)

                // Play a sound
                let player = try AVAudioPlayer(
                    contentsOf: soundFileURL
                )

                player.play()
            }
            catch {
                // Handle error
            }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("First subtask")) {
                    Text("Number of classes")
                        .font(Font.headline)
                    TextField("classes", text: $classes)
                        .keyboardType(.numberPad)
                        .onReceive(Just(classes)) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        if filtered != newValue {
                                            self.classes = filtered
                                        }
                        }
                    
                    Text("Number of days")
                        .font(Font.headline)
                    TextField("days", text: $days)
                        .keyboardType(.numberPad)
                        .onReceive(Just(days)) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        if filtered != newValue {
                                            self.days = filtered
                                        }
                        }
                    
                    Button(action: {
                        if ((Int(days)) != nil) && ((Int(days)) != 0) && ((Int(classes)) != nil) {
                            DispatchQueue.global(qos: .background).async {
                                print("This is run on the background queue")
                                avg = (Int(classes) ?? 0) / (Int(days) ?? 1)
                                DispatchQueue.main.async {
                                    print("This is run on the main queue, after the previous code in outer block")
                                }
                            }
                        }
                    }, label: {
                        Text("Calculate")
                    })
                    
                    Text("Average classes per day: \(avg)")
                }
                
                Section (header: Text("Second subtask")) {
                    HStack {
                        Text("Name")
                            .font(Font.headline)
                        Spacer()
                        Text("Philipp Lazarev")
                    }.padding(5)
                    
                    HStack {
                        Text("Job")
                            .font(Font.headline)
                        Spacer()
                        Text("System Analyst DWH")
                    }.padding(5)
                    
                    HStack {
                        Text("Age")
                            .font(Font.headline)
                        Spacer()
                        Text(age)
                    }.padding(5)
                    
                    Button (action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(22), execute: {
                            age = "22"
                        })
                    }, label: {
                        Text("Show age")
                    })
                }
                
                Section (header: Text("Third task")) {
                    Text(shuffledString)
                    TextField("String", text: $string)
                    Button(action: {
                        var array = [Character]()
                        array = Array(string)
                        array = array.shuffled()
                        shuffledString = String(array).lowercased().capitalized
                    }, label: {
                        Text("Shuffle")
                    })
                }
                
                Section (header: Text("Fourth task")) {
                    Text("Maisie Peters - Glowing Review")
                    Button(action: {
                        playSound()
                    }, label: {
                        HStack {
                            Spacer()
                            Image(systemName: "play.circle")
                                .foregroundColor(.pink)
                            Spacer()
                        }
                    })
                }
            }
            .navigationBarTitle("RTU MIREA")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
