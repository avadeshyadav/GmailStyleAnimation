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


    @IBAction func actionViewProfile(_ sender: AnyObject) {
     
        let navVC = self.storyboard?.instantiateViewController(withIdentifier: "NavigationVC")
        navVC?.modalPresentationStyle = .custom

        self.present(navVC!, animated: true, completion: nil)
    }
}

