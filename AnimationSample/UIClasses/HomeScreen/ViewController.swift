//
//  ViewController.swift
//  AnimationSample
//
//  Created by Avadesh Kumar on 17/03/16.
//  Copyright © 2016 ibibo Group. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func actionViewProfile(sender: AnyObject) {
     
        let navVC = self.storyboard?.instantiateViewControllerWithIdentifier("NavigationVC")
        navVC?.modalPresentationStyle = .Custom

        self.presentViewController(navVC!, animated: true, completion: nil)
    }
}

