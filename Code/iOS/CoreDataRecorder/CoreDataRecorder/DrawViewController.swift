//
//  DrawViewController.swift
//  CoreDataRecorder
//
//  Created by Student on 10/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit
import CoreData

class DrawViewController: UIViewController, NumbersEntryProtocol {
    
    let context = DatabaseController.persistentContainer.viewContext
    
    
    @IBOutlet var NumbersEntryView: NumbersEntryView!
    
    var points = [CGPoint]() {
        didSet {
            updateUI()
        }
    }
    
    func updateUI()
    {
        self.view?.setNeedsDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.NumbersEntryView.delegate =  self
    }
    
    @IBAction func handlepan(_ gesture: UIPanGestureRecognizer) {
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
        case .changed:
            points.append(gesture.location(in: self.view))
            let touch:Touch = NSEntityDescription.insertNewObject(forEntityName: touchClassName, into: context) as! Touch
            //let touch = Touch(context: context)
            touch.x = Double(gesture.location(in: self.view).x)
            touch.y = Double(gesture.location(in: self.view).y)
            touch.index = count + 1
            touch.t = 1234
            stroke.addToTouches(touch)
            self.view.setNeedsDisplay()
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
        default:
            ()
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
