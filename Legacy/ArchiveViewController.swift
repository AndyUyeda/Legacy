//
//  ArchiveViewController.swift
//  Legacy
//
//  Created by Andy Uyeda on 1/9/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

import UIKit

class ArchiveViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var teacher : NSString!
    var site : NSString!
    var urlArray : NSMutableArray!
    var sermonArray : NSMutableArray!
    var seriesName : NSString!
    var type : NSString!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sermonArray = NSMutableArray()
        urlArray = NSMutableArray()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        //println(teacher)
        //println(site)
        if(type!.isEqualToString("Teacher")){
            let url = NSURL(string: site)
            var webData = NSString(contentsOfURL: url!, encoding:NSUTF8StringEncoding, error: nil)
            let searcher = MEStringSearcher(fromString: webData!)
            searcher.moveToString("Sermons")
            var done = false
            while(!done){
                var url = searcher.getStringWithLeftBounds("href=\"", rght: "\"")
                var sermon = searcher.getStringWithLeftBounds("*", rght: "*")
                
                
                if(sermon!.isEqualToString("End")){
                    done = true
                }
                else{
                    let encodedData = sermon!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)
                    
                    let decodedString = attributedString!.string as NSString
                    
                    sermonArray.addObject(decodedString)
                    urlArray.addObject(url!)
                    
                    
                }
                
            }
        }
        if(type!.isEqualToString("Series")){
            let url = NSURL(string: site)
            var webData = NSString(contentsOfURL: url!, encoding:NSUTF8StringEncoding, error: nil)
            let searcher = MEStringSearcher(fromString: webData!)
            searcher.moveToString(seriesName)
            searcher.moveToString("src")
            var done = false
            while(!done){
                var url = searcher.getStringWithLeftBounds("href=\"", rght: "\"")
                var sermon = searcher.getStringWithLeftBounds("*", rght: "*")
                
                
                if(sermon!.isEqualToString("End")){
                    done = true
                }
                else{
                    let encodedData = sermon!.dataUsingEncoding(NSUTF8StringEncoding)!
                    let attributedOptions = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
                    let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)
                    
                    let decodedString = attributedString!.string as NSString
                    
                    sermonArray.addObject(decodedString)
                    urlArray.addObject(url!)
                    
                
                }
            
            }
            var arr = sermonArray.reverseObjectEnumerator().allObjects
            sermonArray = NSMutableArray(array: arr)
            
            var arrr = urlArray.reverseObjectEnumerator().allObjects
            urlArray = NSMutableArray(array: arrr)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sermonArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        var text = sermonArray.objectAtIndex(indexPath.row) as String
        
        var s = "*" + text
        let searcher = MEStringSearcher(fromString: s)
        var sermon = searcher.getStringWithLeftBounds("*", rght: "~")
        
        var t = text + "*"
        let searcher1 = MEStringSearcher(fromString: t)
        var teacher = searcher1.getStringWithLeftBounds("~", rght: "*")
        println(sermon)
        println(teacher)
        cell.textLabel!.text = sermon! + "\n" + teacher!
        cell.textLabel!.numberOfLines = 2
        cell.textLabel!.font = UIFont (name: "Copperplate", size: 14)
        //println(sermonArray.count)
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int)
        -> String {
            if(type!.isEqualToString("Teacher")){
                return teacher
            }
            else{
                return seriesName
            }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("sermon", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var path = tableView.indexPathForSelectedRow()
        var avc = segue.destinationViewController as AudioViewController
        
        avc.site = urlArray.objectAtIndex(path!.row) as NSString
        var text = sermonArray!.objectAtIndex(path!.row) as String
        
        var s = "*" + text
        let searcher = MEStringSearcher(fromString: s)
        var sermon = searcher.getStringWithLeftBounds("*", rght: "~")
        
        var t = text + "*"
        let searcher1 = MEStringSearcher(fromString: t)
        var teacher = searcher1.getStringWithLeftBounds("~", rght: "*")
        avc.theTitle = sermon
        avc.teacher = teacher
    }
    
    @IBAction func wentBack(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}