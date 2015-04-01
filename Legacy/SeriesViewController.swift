//
//  SeriesViewController.swift
//  Legacy
//
//  Created by Andy Uyeda on 1/12/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

import UIKit

class SeriesViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var location : NSInteger!
    var seriesTitles : NSMutableArray!
    var images : NSMutableArray!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //println(location)
        seriesTitles = NSMutableArray()
        images = NSMutableArray()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        let url = NSURL(string: "https://sites.google.com/site/legacyfamarchive/home/north-side")
        var webData = NSString(contentsOfURL: url!, encoding:NSUTF8StringEncoding, error: nil)
    
        if(webData == nil){
            println("Try Again Later")
            return
        }
        let searcher = MEStringSearcher(fromString: webData!)
        println(webData)
        //println(webData)
        searcher.moveToString("Series")
        
        var done = false
        while(!done){
            var seriesName = searcher.getStringWithLeftBounds(">-", rght: "-")
            var imgURL = searcher.getStringWithLeftBounds("href=\"", rght: "\"")
            if(seriesName == nil){
                done = true
            }
            else{
                
                println(imgURL)
                seriesTitles.addObject(seriesName!)
                let ul = NSURL(string: imgURL as String)
                let data = NSData(contentsOfURL: ul!)
                let img = UIImage(data: data!)
                let im = self.RBResizeImage(img!, targetSize: CGSizeMake(30, 30))
                images.addObject(im)
            }
        
        
        
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seriesTitles.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = seriesTitles.objectAtIndex(indexPath.row) as? String
        cell.textLabel!.font = UIFont (name: "Copperplate", size: 14)
        cell.imageView?.contentMode = UIViewContentMode.Center
        cell.imageView!.image = images.objectAtIndex(indexPath.row) as? UIImage
        return cell
    }
    func tableView(tableView: UITableView,
        titleForHeaderInSection section: Int)
        -> String {
            return "Series"
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func wentBack(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func teacherPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("teacher", sender: self)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("series", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "teacher"){
            var tvc = segue.destinationViewController as TeacherViewController
            tvc.location = location
        }
        if(segue.identifier == "series"){
            var path = tableView.indexPathForSelectedRow()
            var avc = segue.destinationViewController as ArchiveViewController
            avc.seriesName = seriesTitles.objectAtIndex(path!.row) as NSString
            avc.site = "https://sites.google.com/site/legacyfamarchive/home/north-side"
            avc.type = "Series"
            
        }
    
    }
    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }


    
}