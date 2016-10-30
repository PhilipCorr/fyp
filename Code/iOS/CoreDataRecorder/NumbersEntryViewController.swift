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
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let context = DatabaseController.persistentContainer.viewContext
        //let stroke = Stroke(context: context)
        let touchClassName:String = String(describing: Touch.self)
        let strokeClassName:String = String(describing: Stroke.self)
        let stroke = NSEntityDescription.insertNewObject(forEntityName: strokeClassName, into: context) as! Stroke
        let count = 0
        
       // stroke.addToTouches(touch)
        
        switch gesture.state {
        case .began:
            self.points = [CGPoint]()
            print("start of stroke")
        case .ended:
            print("end of stroke")
            DatabaseController.saveContext()
            let fetchRequest:NSFetchRequest<Touch> = Touch.fetchRequest()
            do{
                let searchResults = try context.fetch(fetchRequest)
                print("Number of results: \(searchResults.count)")
                for result in searchResults as [Touch]{
                    print("x is \(result.x), y is \(result.y) at time t=\(result.t)")
                }
            }
            catch{
                print("Error: \(error).self")
            }
                // self.age = self.points.count
        case .changed:
            self.points.append(gesture.location(in: self.view))
            let touch:Touch = NSEntityDescription.insertNewObject(forEntityName: touchClassName, into: context) as! Touch
            //let touch = Touch(context: context)
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

