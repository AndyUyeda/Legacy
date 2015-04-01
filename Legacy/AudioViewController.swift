//
//  AudioViewController.swift
//  Legacy
//
//  Created by Andy Uyeda on 12/29/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox



class AudioViewController: UIViewController, NSURLConnectionDelegate{
    
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
    var audioPlayer = AVPlayer()
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
    var conn : NSURLConnection!
    var fileData : NSMutableData!
    var totalFileSize : Int64!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileData = NSMutableData()
        teacherLabel.text = teacher
        //let url = NSURL(fileURLWithPath: "http://www.ibclouisville.org/new/wordpress/wp-content/uploads/2014/12/2014_12_14Rfullerton.mp3")
        /*let path = NSBundle.mainBundle().pathForResource("MARK", ofType:"mp3")
        let url = NSURL.fileURLWithPath(path!)
        
        audioPlayer = AVPlayer(URL: url)
        audioPlayer.volume = 1.0
        audioPlayer.play()*/
        downed = false
        downloading = false
        let url = site//"http://www.mediafire.com/?q4zyze7kt6g4ecx"//site
        playerURL = url
        let playerItem = AVPlayerItem( URL:NSURL( string:url ) )
        audioPlayer = AVPlayer(playerItem:playerItem)
        audioPlayer.rate = 1.0;
        audioPlayer.play()
        
        let duration = CMTimeAbsoluteValue(audioPlayer.currentItem.asset.duration)
        totalSeconds = CMTimeGetSeconds(duration);
        
        let currentTime = CMTimeAbsoluteValue(audioPlayer.currentTime())
        currentSeconds = CMTimeGetSeconds(currentTime);
        
        isPaused = false;
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target:self, selector:Selector("update"), userInfo:nil, repeats:true)
        titleLabel.text = theTitle
        
    }
    
    func update(){
        
        let currentTime = CMTimeAbsoluteValue(audioPlayer.currentTime())
        currentSeconds = CMTimeGetSeconds(currentTime)
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
        var s = Int64(sec)
        let newTime : CMTime = CMTimeMake(s, 1)
        audioPlayer.seekToTime(newTime)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButtonSelected(sender: UIButton) {
        audioPlayer.pause()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func paused(sender: UIButton) {
        if(!isPaused){
            isPaused = true;
            audioPlayer.pause()
            var img = UIImage(named: "play-disabled-1.png")
            pauseButton.setImage(img, forState: .Normal)
        }
        else{
            var img = UIImage(named: "pause-disabled.png")
            pauseButton.setImage(img, forState: .Normal)
            isPaused = false;
            audioPlayer.play()
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
        let newTime : CMTime = CMTimeMake(final, 1)
        audioPlayer.seekToTime(newTime)
        
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        hourField.resignFirstResponder()
        minuteField.resignFirstResponder()
        secondField.resignFirstResponder()
    }
    
    @IBAction func downloaded(sender: AnyObject) {
        
        if let titles1 = NSUserDefaults.standardUserDefaults().objectForKey("sermonTitles") as? NSMutableArray{
            let titles2 = NSUserDefaults.standardUserDefaults().objectForKey("sermonTitles") as NSMutableArray
            titles = titles2.mutableCopy() as NSMutableArray
            //println("worked1")
            println(titles)
        }
        else{
            titles = NSMutableArray()
            //println("worked2")
        }
        if let teacherNames1 = NSUserDefaults.standardUserDefaults().objectForKey("teacherNames") as? NSMutableArray{
            let teacherNames2 = NSUserDefaults.standardUserDefaults().objectForKey("teacherNames") as NSMutableArray
            teacherNames = teacherNames2.mutableCopy() as NSMutableArray
        }
        else{
            teacherNames = NSMutableArray()
        }
        var alreadyExists = false
        
        println(titles)
        
        if(titles.count > 0){
            var count = titles.count as Int
            for title in titles{
                if(title.isEqual(theTitle)){
                    alreadyExists = true
                }
            }
        }
        
        if(!alreadyExists && !downed){
            downloading = true;
            downed = true;
            
            var req = NSURLRequest(URL: NSURL(string: site)!)
            conn = NSURLConnection(request: req, delegate: self)
            
        }
    }
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse){
        //println("started")
        showProgress.hidden = false
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        fileData.length = 0
        totalFileSize = response.expectedContentLength
    }
    func connection(connection: NSURLConnection, didReceiveData data: NSData){
        fileData.appendData(data)
        var l = Float(fileData.length)
        var t = Float(totalFileSize)
        var progressive = l / t
        showProgress.setProgress(progressive, animated: true)
    }
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    func connection(connection: NSURLConnection, willCacheResponse cachedResponse: NSCachedURLResponse) -> NSCachedURLResponse?{
        return nil
    }
    func connectionDidFinishLoading(connection: NSURLConnection){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        var str = "Documents/" + theTitle + ".mp3"
        var path = NSHomeDirectory().stringByAppendingPathComponent(str)
        showProgress.hidden = true
        println(path)
        
        if((fileData.writeToFile(path, options: NSDataWritingOptions.DataWritingAtomic, error: nil)) == false){
            let alert = UIAlertView(title: "ERROR", message: "Audio Could Not Download", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        else{
            downloading = false
            titles?.addObject(theTitle)
            teacherNames?.addObject(teacher)
            
            //titles.removeAllObjects()
            //teacherNames.removeAllObjects()
            
            NSUserDefaults.standardUserDefaults().setObject(titles, forKey: "sermonTitles")
            NSUserDefaults.standardUserDefaults().setObject(teacherNames, forKey: "teacherNames")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let alert = UIAlertView(title: "Success", message: "Audio Downloaded Successfully", delegate: nil, cancelButtonTitle: "Great")
            alert.show()
            
        }
    }
    
    override func viewWillDisappear(animated:Bool) {
        super.viewWillDisappear(animated)
        audioPlayer.pause()
        
        if(downloading!){
            conn.cancel()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            let alert = UIAlertView(title: "Error", message: "Audio Did Not Finish Downloading", delegate: nil, cancelButtonTitle: "Alright")
            alert.show()
        
        }
        
    
    }
    
    
    
    
}





