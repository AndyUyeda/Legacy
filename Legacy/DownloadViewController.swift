//
//  DownloadViewController.swift
//  Legacy
//
//  Created by Andy Uyeda on 1/17/15.
//  Copyright (c) 2015 Andy Uyeda. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titleList : NSMutableArray!
    var teachers: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        if let titles1 = NSUserDefaults.standardUserDefaults().objectForKey("sermonTitles") as? NSMutableArray{
            let titles2 = NSUserDefaults.standardUserDefaults().objectForKey("sermonTitles") as NSMutableArray
            titleList = titles2.mutableCopy() as NSMutableArray
            //println("worked1")
            println(titleList)
        }
        else{
            titleList = NSMutableArray()
            //println("worked2")
        }
        if let teacherNames1 = NSUserDefaults.standardUserDefaults().objectForKey("teacherNames") as? NSMutableArray{
            let teacherNames2 = NSUserDefaults.standardUserDefaults().objectForKey("teacherNames") as NSMutableArray
            teachers = teacherNames2.mutableCopy() as NSMutableArray
        }
        else{
            teachers = NSMutableArray()
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        if let titles1 = NSUserDefaults.standardUserDefaults().objectForKey("sermonTitles") as? NSMutableArray{
            let titles2 = NSUserDefaults.standardUserDefaults().objectForKey("sermonTitles") as NSMutableArray
            titleList = titles2.mutableCopy() as NSMutableArray
            //println("worked1")
            println(titleList)
        }
        else{
            titleList = NSMutableArray()
            //println("worked2")
        }
        if let teacherNames1 = NSUserDefaults.standardUserDefaults().objectForKey("teacherNames") as? NSMutableArray{
            let teacherNames2 = NSUserDefaults.standardUserDefaults().objectForKey("teacherNames") as NSMutableArray
            teachers = teacherNames2.mutableCopy() as NSMutableArray
        }
        else{
            teachers = NSMutableArray()
        }
        tableView.reloadData()
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        var title = titleList!.objectAtIndex(indexPath.row) as String
        var teach = teachers!.objectAtIndex(indexPath.row) as String
        cell.textLabel!.text = title + "\n" + teach
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
            return "Downloads"
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("audiodownload", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var path = tableView.indexPathForSelectedRow()
        var avc = segue.destinationViewController as AudDownViewController
        avc.theTitle = titleList.objectAtIndex(path!.row) as NSString
        avc.teacher = teachers.objectAtIndex(path!.row) as NSString
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var error : NSError?
        var t = titleList.objectAtIndex(indexPath.row) as NSString
        var str = "Documents/" + t + ".mp3"
        NSFileManager.defaultManager().removeItemAtPath(NSHomeDirectory().stringByAppendingPathComponent(str), error: &error)
        titleList.removeObjectAtIndex(indexPath.row)
        teachers.removeObjectAtIndex(indexPath.row)
        
        NSUserDefaults.standardUserDefaults().setObject(titleList, forKey: "sermonTitles")
        NSUserDefaults.standardUserDefaults().setObject(teachers, forKey: "teacherNames")
        tableView.reloadData()
        NSUserDefaults.standardUserDefaults().synchronize()
        
        
        
    }
    
    
}