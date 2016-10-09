//
//  ViewController.swift
//  Test
//
//  Created by Me on 27/09/2016.
//  Copyright © 2016 GS. All rights reserved.
//

import UIKit

class EnterNumbersViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet var myView: MyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myLabel.text = "1234"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            myView.points = [CGPoint]()
            myView.setNeedsDisplay()
            // print("start of stroke")
        case .ended:
            // print("end of stroke")
            // print("\(myView.points)")
            ()
        case .changed:
            self.myView.points.append(gesture.location(in: self.view))
            self.myView.setNeedsDisplay()
        default:
            ()
        }
    }

    @IBAction func changeNumber(_ sender: UITapGestureRecognizer) {
        myLabel.text = "5678"
    }
}

