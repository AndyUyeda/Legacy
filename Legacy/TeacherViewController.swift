//
//  TeacherViewController.swift
//  Legacy
//
//  Created by Andy Uyeda on 12/28/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

import UIKit

class TeacherViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var location : NSInteger!
    var teacher : NSString!
    var site : NSString!
    var urlArray : NSMutableArray!
    
    var h : CGFloat!
    var w : CGFloat!
    var tag : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        urlArray = NSMutableArray()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        w = screenSize.width
        h = screenSize.height
        
        if(location == 1){
            
        }
        if(location == 2){
            
        }
        
        let url = NSURL(string: "https://sites.google.com/site/legacyfamarchive/home/north-side")
        var webData = NSString(contentsOfURL: url!, encoding:NSUTF8StringEncoding, error: nil)
        
        let searcher = MEStringSearcher(fromString: webData!)
        if(webData == nil){
            println("Try Again Later")
            return
        }
        //println(webData)
        //println(webData)
        searcher.moveToString("Teachers")
        
        var done = false
        var x = 0 as CGFloat
        var y = 0 as CGFloat
        tag = 0
        while(!done){
            var teacherURL = searcher.getStringWithLeftBounds("href=\"", rght: "\"")
            var teacherName = searcher.getStringWithLeftBounds("img alt=\"", rght: "\"")
            var archiveURL = searcher.getStringWithLeftBounds("a href=\"" , rght: "\"")
            urlArray.addObject(archiveURL!)
            
            if(teacherName == nil){
                if(x == 0){
                    y = y - 1
                }
                done = true
            }
            else{
                //println(teacherName)
                let button = UIButton()
                let ul = NSURL(string: teacherURL!)
                let data = NSData(contentsOfURL: ul!)
                let img = UIImage(data: data!)
                button.setImage(img!, forState: .Normal)
                button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
                button.tag = tag
                tag = tag + 1
                button.titleLabel?.text = teacherName
                button.titleLabel?.hidden = true
                button.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
                
                let label = UILabel()
                label.text = teacherName
                label.font = UIFont (name: "Copperplate", size: 10)
                label.textColor = UIColor(white: 1, alpha: 1)
                var tN = teacherName as NSString!
                let size: CGSize = tN.sizeWithAttributes([NSFontAttributeName: UIFont (name: "Copperplate", size: 10)!])
                
                if(x == 0){
                    button.frame = CGRectMake(20, 120 * y + 10, 79, 79)
                }
                if(x == 1){
                    button.frame = CGRectMake((w / 2) - (79 / 2), 120 * y + 10, 79, 79)
                }
                if(x == 2){
                    button.frame = CGRectMake(w - 99, 120 * y + 10, 79, 79)
                    //println(w - button.bounds.width - 79)
                    //println(w - (button.bounds.width * 2))
                }
                
                label.frame = CGRectMake(button.frame.midX - (size.width / 2), (120 * y + 10) + 39, 200, 100)
                self.scrollView.addSubview(label)
                //println(label.frame.width)
                
                self.scrollView.addSubview(button)
                x = x + 1
                if(x > 2){
                    x = 0
                    y = y + 1
                }
            }
        }
        scrollView.contentSize = CGSizeMake(315, 40 + (y * (120) + 79))
        //println(y)
        
        
    }
    
    func buttonAction(sender:UIButton!) {
        var btnsendtag:UIButton = sender
        //println(btnsendtag.tag)
        teacher = btnsendtag.titleLabel?.text
        site = urlArray.objectAtIndex(btnsendtag.tag) as NSString
        //println(teacher)
        //println(urlArray.objectAtIndex(btnsendtag.tag))
        self.performSegueWithIdentifier("audio", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var avc = segue.destinationViewController as ArchiveViewController
        avc.teacher = teacher
        avc.type = "Teacher"
        avc.site = self.site
    }
    
    @IBAction func backButtonSelected(sender: UIButton) {
        //var teacherViewController =
        //performSegueWithIdentifier("location", sender: sender)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

