//
//  FirstViewController.swift
//  Legacy
//
//  Created by Andy Uyeda on 12/27/14.
//  Copyright (c) 2014 Andy Uyeda. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var loc = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tabBarController?.tabBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func northSideSelected(sender: UIButton) {
        loc = 1
        self.performSegueWithIdentifier("series", sender: self)
    }
    @IBAction func eastGarfieldSelected(sender: UIButton) {
        loc = 2
        self.performSegueWithIdentifier("series", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var svc = segue.destinationViewController as SeriesViewController
        svc.location = loc
    }
    


}

