//
//  SecondViewController.swift
//  Legacy
//
//  Created by Andy Uyeda on 12/27/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var connect: UILabel!
    @IBOutlet weak var seed: UILabel!
    
    var failed = false
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.delegate = self
        webView.scalesPageToFit = true
        let urlPath: String = "https://www.formstack.com/forms/?1499380-xeEsWiKIEF"
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        webView.loadRequest(request1)
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.4, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    
    func update(){
        if(!failed){
            counter++
            if(counter == 0){
                label1.hidden = false
                label2.hidden = true
                label3.hidden = true
                label4.hidden = true
            }
            if(counter == 1){
                label2.hidden = false
                label1.hidden = true
                label3.hidden = true
                label4.hidden = true
                
            }
            if(counter == 2){
                label3.hidden = false
                label1.hidden = true
                label2.hidden = true
                label4.hidden = true
            }
            if(counter == 3){
                label4.hidden = false
                label1.hidden = true
                label2.hidden = true
                label3.hidden = true
                counter = -1
            }
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
        print("Webview fail with error \(error)");
        failed = true
        
        label1.hidden = true
        label2.hidden = true
        label3.hidden = true
        label4.hidden = true
        
        connect.hidden = false
        seed.hidden = false
    }
    
    func webViewDidStartLoad(webView: UIWebView!) {
        print("Webview started Loading")
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        print("Webview did finish load")
        failed = true
        label1.hidden = true
        label2.hidden = true
        label3.hidden = true
        label4.hidden = true
        
        webView.hidden = false;
    }
    
}

