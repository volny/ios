//
//  PlayViewController.swift
//  Pitch Perfect
//
//  Created by felix on 8/3/15.
//  Copyright (c) 2015 Volnyio. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController {
    var audioPlayer:AVAudioPlayer!
    // we want to receive data from the recordVC
    var receivedAudio:RecordedAudio! // type: NSURL to our audiofile
    // we need to convert the NSURL to an AVAudioFile. we'll use `audioFile` for that
    var audioFile:AVAudioFile!
    // we use AVAudioEngine to manipulate sound
    var audioEngine:AVAudioEngine!
    
    override func viewDidLoad() { super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        // required for playback rate manipulation
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        
        // `forReading` converts an NSUrl to an AVAudio file - just what we need
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // for reasons unknown this breaks if I use `sender: UIButton`
    @IBAction func slowPlayback(sender: AnyObject) {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        
        audioPlayer.rate = 0.75
        audioPlayer.play()
    }

    @IBAction func fastPlayback(sender: AnyObject) {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        
        audioPlayer.rate = 1.75
        audioPlayer.play()
    }
    
    @IBAction func ChipmunkPlayback(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
        }
    
    @IBAction func VaderPlayback(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        // attach the node we just made to the audioEngine
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitch = AVAudioUnitTimePitch()
        // pitch is the argument this function is taking
        changePitch.pitch = pitch
        audioEngine.attachNode(changePitch)
        
        // connect the pitch effect to the player node
        audioEngine.connect(audioPlayerNode, to: changePitch, format: nil)
        // connect to the effect to the audio output i.e. speakers etc
        audioEngine.connect(changePitch, to: audioEngine.outputNode, format: nil)
        
        // actually play the audio
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
}
