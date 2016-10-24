//
//  ViewController.swift
//  Test
//
//  Created by Me on 27/09/2016.
//  Copyright © 2016 GS. All rights reserved.
//

import UIKit
import CoreData

class NumbersEntryViewController: UIViewController, NumbersEntryProtocol {
    
    @IBOutlet var ageLabel: UILabel!
    
    @IBOutlet var NumbersEntryView: NumbersEntryView!
    
    var age: Int = 99 {
        didSet {
            updateUI()
        }
    }
    
    func updateUI()
    {
        self.ageLabel?.text = "\(age)"
        self.NumbersEntryView?.setNeedsDisplay()
    }
    
    var points = [CGPoint]() {
        didSet {
            updateUI()
        }
    }
    
   // @IBOutlet var NumbersEntryView: NumbersEntryView!
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.NumbersEntryView.delegate =  self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let stroke = Stroke(context: context)
        let count = 0
        
       // stroke.addToTouches(touch)
        
        switch gesture.state {
        case .began:
            self.points = [CGPoint]()
            print("start of stroke")
        case .ended:
            print("end of stroke")
        // self.age = self.points.count
        case .changed:
            self.points.append(gesture.location(in: self.view))
            let touch = Touch(context: context)
            touch.x = Double(gesture.location(in: self.view).x)
            touch.y = Double(gesture.location(in: self.view).y)
            touch.index = count + 1
            touch.t = 1234
            stroke.addToTouches(touch)
            self.NumbersEntryView.setNeedsDisplay()
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

