//
//  ViewController.swift
//  Test
//
//  Created by Me on 27/09/2016.
//  Copyright © 2016 GS. All rights reserved.
//

import UIKit

class EnterNumbersViewController: UIViewController, EnterNumbersProtocol {
    
    @IBOutlet var ageLabel: UILabel!
    var age: Int = 99 {
        didSet {
            updateUI()
        }
    }
    
    func updateUI()
    {
        self.ageLabel?.text = "\(age)"
        self.enterNumbersView?.setNeedsDisplay()
    }
    
    var points = [CGPoint]() {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet var enterNumbersView: EnterNumbersView!
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.enterNumbersView.delegate =  self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            self.points = [CGPoint]()
            print("start of stroke")
        case .ended:
            print("end of stroke")
            // print("\(self.points)")
            // self.age = self.points.count
        case .changed:
            self.points.append(gesture.location(in: self.view))
            self.enterNumbersView.setNeedsDisplay()
        default:
            ()
        }
    }
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        if let dvc = subsequentVC as? DetailsEntryViewController {
            dvc.touchesCount = self.points.count
        }
    }
    
}

