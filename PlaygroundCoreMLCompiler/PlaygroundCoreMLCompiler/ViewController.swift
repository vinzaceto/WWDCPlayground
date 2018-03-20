//
//  ViewController.swift
//  PlaygroundCoreMLCompiler
//
//  Created by Vincenzo Aceto on 20/03/2018.
//  Copyright © 2018 Vincenzo Aceto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let model = hand_recognizer_model()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

