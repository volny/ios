//
//  RecordViewController.swift
//  Pitch Perfect
//
//  Created by felix on 8/2/15.
//  Copyright (c) 2015 Volnyio. All rights reserved.
//

import UIKit

import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    // `outlet` assigns a UI element to a var basically
    @IBOutlet weak var recordingInProgressLabel: UILabel!
    @IBOutlet weak var TapToRecord: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    
    // link to our Models file `RecordedAudio.swift`
    var recordedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        println("recording in progress")
        TapToRecord.hidden = true
        recordingButton.enabled = false
        recordingInProgressLabel.hidden = false
        stopButton.hidden = false


        // Actually record
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // initialize and prepare recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self // see class definition - we delegate `AVAudioRecorder` to this class
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    // this is why we inherit (delegate) this class from AVAudioRecorderDelegate
    // we want to make sure we don't move to the new scene until the audio is ready for playback
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        // if recording was sucessful ...
        if (flag) {
        // look at the Model (RecordedAudio.swift) to understand what's going on here
        recordedAudio = RecordedAudio()
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent

        // perform segue i.e. move to next scene
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
            
        TapToRecord.hidden = false
            
        } else {
            println("Recored unsuccessful")
            recordingButton.enabled = true
            stopButton.hidden = true
        }
    }

    // just before the seque is performed is a good time to pass over data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playVC:PlayViewController = segue.destinationViewController as! PlayViewController
            let data = sender as! RecordedAudio // see the perform segue line a few lines up
            playVC.receivedAudio = data // reference to the var inside `PlayViewController.swift`
        }
    }

    @IBAction func StopRecording(sender: UIButton) {
        recordingButton.enabled = true
        recordingInProgressLabel.hidden = true
        stopButton.hidden = true
        
        println("recording stopped")
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)

    }
}

