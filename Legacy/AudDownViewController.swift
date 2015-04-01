//
//  AudDownViewController.swift
//  Legacy
//
//  Created by Andy Uyeda on 1/17/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox



class AudDownViewController: UIViewController, NSURLConnectionDelegate{
    
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var seekButton: UIButton!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var hourField: UITextField!
    @IBOutlet weak var minuteField: UITextField!
    @IBOutlet weak var secondField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showProgress: UIProgressView!
    
    var teacher : NSString!
    var site : NSString!
    var player = AVAudioPlayer()
    var totalSeconds : Float64!
    var currentSeconds : Float64!
    var isPaused : Bool!
    var seconds : NSString!
    var rseconds : NSString!
    var hourMinute : NSString!
    var rhourMinute : NSString!
    var titles : NSMutableArray!
    var teacherNames : NSMutableArray!
    var theTitle : NSString!
    var downed : Bool!
    var downloading : Bool!
    var playerURL : String!
    var fileData : NSMutableData!
    var totalFileSize : Int64!
    
    
    func initPlayer(){
        //player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@%@",@"Documents/",theTitle,@".mp3"]]] error:nil];
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setCategory(AVAudioSessionCategoryPlayback, error:&error) {
            println("could not set session category")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.setActive(true, error: &error) {
            println("could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        session.setActive(true, error: &error)
    
        var str = "Documents/" + theTitle + ".mp3"
        player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSHomeDirectory() .stringByAppendingPathComponent(str)), error: nil)
        
        
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fileData = NSMutableData()
        teacherLabel.text = teacher
        downed = false
        downloading = false
        self.initPlayer()
        player.play()
        
        
        totalSeconds = player.duration
        
        let currentTime = player.currentTime
        currentSeconds = currentTime
        
        isPaused = false;
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target:self, selector:Selector("update"), userInfo:nil, repeats:true)
        titleLabel.text = theTitle
        
    }
    
    func update(){
        
        let currentTime = player.currentTime
        currentSeconds = currentTime
        var f = Float(currentSeconds)
        var d = Float(totalSeconds)
        
        var percent = f / d
        slider.value = percent
        
        var remainingSeconds = totalSeconds - currentSeconds
        if(totalSeconds < 3600){
            var cm = currentSeconds / 60
            var currentMinute = Int(cm)
            var cs = currentSeconds % 60
            var currentSec = Int(cs)
            
            if(currentSec < 10){
                seconds = "0\(currentSec)"
            }
            else{
                seconds = "\(currentSec)"
            }
            startTime.text = "\(currentMinute):\(seconds)"
            
            var rm = remainingSeconds / 60
            var remainingMinute = Int(rm)
            var rs = remainingSeconds % 60;
            var remainingSec = Int(rs)
            
            if(remainingSec < 10){
                rseconds = "0\(remainingSec)"
            }
            else{
                rseconds = "\(remainingSec)"
            }
            endTime.text = "\(remainingMinute):\(rseconds)"
        }
        else{
            var ch = currentSeconds / 3600
            var currentHour = Int(ch)
            var ccs = Int(currentSeconds)
            var cd = (ccs - (currentHour * 3600))
            var currentD = Int(cd)
            var cm = currentD / 60
            var currentMinute = Int(cm)
            var cs = currentD % 60
            var currentSec = Int(cs)
            
            if(currentSec < 10){
                seconds = "0\(currentSec)"
            }
            else{
                seconds = "\(currentSec)"
            }
            if(currentMinute < 10){
                hourMinute = "0\(currentMinute)"
            }
            else{
                hourMinute = "\(currentMinute)"
            }
            startTime.text = "\(currentHour):\(hourMinute):\(seconds)"
            
            var rh = remainingSeconds / 3600
            var remainingHour = Int(rh)
            var rrs = Int(remainingSeconds)
            var rd = (rrs - (remainingHour * 3600))
            var remainingD = Int(rd)
            var rm = remainingD / 60
            var remainingMinute = Int(rm)
            var rs = remainingD % 60
            var remainingSec = Int(rs)
            
            if(remainingSec < 10){
                rseconds = "0\(remainingSec)"
            }
            else{
                rseconds = "\(remainingSec)"
            }
            if(remainingMinute < 10){
                rhourMinute = "0\(remainingMinute)"
            }
            else{
                rhourMinute = "\(remainingMinute)"
            }
            endTime.text = "\(remainingHour):\(rhourMinute):\(rseconds)"
        }
        
    }
    @IBAction func sliderChanged(sender: UISlider) {
        var ts = Float(totalSeconds)
        var sec = slider.value * ts
        var p = NSTimeInterval(sec)
        var s = Int64(sec)
        let newTime : CMTime = CMTimeMake(s, 1)
        //player.seekToTime(newTime)
        player.currentTime = p
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButtonSelected(sender: UIButton) {
        player.pause()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func paused(sender: UIButton) {
        if(!isPaused){
            isPaused = true;
            player.pause()
            var img = UIImage(named: "play-disabled-1.png")
            pauseButton.setImage(img, forState: .Normal)
        }
        else{
            var img = UIImage(named: "pause-disabled.png")
            pauseButton.setImage(img, forState: .Normal)
            isPaused = false;
            player.play()
        }
        
    }
    @IBAction func seekPosition(sender: UIButton) {
        hourField.text = ""
        minuteField.text = ""
        secondField.text = ""
        
        backButton.hidden = true
        hourField.hidden = false
        minuteField.hidden = false
        secondField.hidden = false
        hourLabel.hidden = false
        minuteLabel.hidden = false
        secondLabel.hidden = false
        seekButton.hidden = false
        undoButton.hidden = false
        
    }
    @IBAction func undid(sender: UIButton) {
        hourField.resignFirstResponder()
        minuteField.resignFirstResponder()
        secondField.resignFirstResponder()
        
        backButton.hidden = false
        hourField.hidden = true
        minuteField.hidden = true
        secondField.hidden = true
        hourLabel.hidden = true
        minuteLabel.hidden = true
        secondLabel.hidden = true
        seekButton.hidden = true
        undoButton.hidden = true
        
    }
    @IBAction func sought(sender: UIButton) {
        hourField.resignFirstResponder()
        minuteField.resignFirstResponder()
        secondField.resignFirstResponder()
        
        backButton.hidden = false
        hourField.hidden = true
        minuteField.hidden = true
        secondField.hidden = true
        hourLabel.hidden = true
        minuteLabel.hidden = true
        secondLabel.hidden = true
        seekButton.hidden = true
        undoButton.hidden = true
        
        var ht = hourField.text as NSString
        var mt = minuteField.text as NSString
        var st = secondField.text as NSString
        var hour : Int!
        var minute : Int!
        var second : Int!
        
        if(ht.length < 1){
            hour = 0
        }
        else{
            hour = hourField.text.toInt()
        }
        if(mt.length < 1){
            minute = 0;
        }
        else{
            minute = minuteField.text.toInt()
        }
        if(st.length < 1){
            second = 0;
        }
        else{
            second = secondField.text.toInt()
        }
        
        var totSec = (hour*3600) + (minute * 60) + second
        
        let tts : Int64 = Int64(totSec)
        let tss : Int64 = Int64(totalSeconds)
        if(tts > tss){
            let tts = tss
        }
        if(tts <= 0){
            let tts = 0;
        }
        let final : Int64 = Int64(tts)
        var d = NSTimeInterval(final)
        let newTime : CMTime = CMTimeMake(final, 1)
        player.currentTime = d
        
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        hourField.resignFirstResponder()
        minuteField.resignFirstResponder()
        secondField.resignFirstResponder()
    }
    
    override func viewWillDisappear(animated:Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
    
    
    
    
}
