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
    
    let context = DatabaseController.persistentContainer.viewContext
    
    @IBOutlet var NumbersEntryView: NumbersEntryView!
    
    @IBOutlet var progression: UILabel!
    
    var count = 1
    var complete = false
    
    func updateUI()
    {
        self.NumbersEntryView?.setNeedsDisplay()
    }
    
    var points = [CGPoint]() {
        didSet {
            updateUI()
        }
    }
    
    @IBAction func nextNumber(_ sender: UIButton) {
        
        if complete {
         points = [CGPoint]()
         updateUI()
         return
        }
        
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
        
        if(count == 40){
            complete = true
            self.performSegue(withIdentifier: "completionSegue", sender: self)
            count -= 1
        }
        
        points = [CGPoint]()
        updateUI()
        
        count += 1
        progression.text = "\(count)/40"
        
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
        //let stroke = Stroke(context: context)
        let touchClassName:String = String(describing: Touch.self)
        let strokeClassName:String = String(describing: Stroke.self)
        let stroke = NSEntityDescription.insertNewObject(forEntityName: strokeClassName, into: context) as! Stroke
        let count = 0
        
        switch gesture.state {
        case .began:
            //self.points = [CGPoint]()
            print("start of stroke")
        case .ended:
            print("end of stroke")
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

//    func prepare(for segue: "completionSegue", sender: AnyObject?) {
//        if segue.identifier == "completionSegue" {
//            if let viewController = segue.destination as? HappinessViewController {
//                //viewController.property = property
//            }
//        }
//    }
    
//    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
//        if let dvc = subsequentVC as? DetailsEntryViewController {
//            dvc.touchesCount = self.points.count
//        }
//    }
    
}

