//
//  SoundController.swift
//  DemonsCave
//
//  Created by Admin on 23.03.16.
//  Copyright © 2016 demensdeum. All rights reserved.
//

import AVFoundation

class DCSoundController
{
    var soundDictionary = [String : URL]();
    var audioPlayer = AVAudioPlayer();
    
    func addSound(_ key : String)
    {
        guard let soundURL = Bundle.main.url(forResource: key, withExtension: "m4a") else { return }
        soundDictionary[key] = soundURL as URL
    }
    
    func playSound(key : String)
    {
        let soundURL = soundDictionary[key]
        if (soundURL != nil)
        {
            do
            {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
            audioPlayer.play()
            }
            catch
            {
            }
        }
    }
}
