//
//  GlyphVC.swift
//  GlyphRecognizer
//
//  Created by Student on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class GlyphVC: UIViewController, NumbersEntryProtocol {
    // dataModel
    public var glyph: Glyph?
    
    let context = DatabaseController.persistentContainer.viewContext
    let date = Date()
    let calendar = Calendar.current
    var charTime = [CFAbsoluteTime]()
    var stroke: Stroke?
    
    @IBOutlet var NumbersEntryView: NumbersEntryView!
    
    var points = [CGPoint]() {
        didSet {
            updateUI()
        }
    }
    
    var pointsInStroke = [Int]()
    
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
        let numPoints = 0
        var startTime = 0.0
        let timer = Timer()
        
        switch gesture.state {
        case .began:
            print("start of stroke")
            startTime = timer.start()
            stroke =  Stroke(context: DatabaseController.persistentContainer.viewContext)
        case .changed:
            if let stroke =  self.stroke {
                let touch = Touch(context: DatabaseController.persistentContainer.viewContext)
                points.append(gesture.location(in: self.view))
                touch.x = Double(gesture.location(in: self.view).x)
                touch.y = Double(gesture.location(in: self.view).y)
                touch.index = numPoints + 1
                touch.t = CFAbsoluteTimeGetCurrent()
                stroke.addToTouches(touch)
                self.view.setNeedsDisplay()
            }
        case .ended:
            if let stroke =  self.stroke {
                self.stroke.t = startTime - timer.stop()
                charTime.append(self.stroke.t)
                points.append(CGPoint(x: -1, y: -1))
                pointsInStroke.append(numPoints)
                print("end of stroke")
                character.addToStrokes(stroke)
                DatabaseController.saveContext()
                //            let fetchRequest:NSFetchRequest<Touch> = Touch.fetchRequest()
                //            do{
                //                let searchResults = try context.fetch(fetchRequest)
                //                print("Number of results: \(searchResults.count)")
                //                for result in searchResults as [Touch]{
                //                    print("x is \(result.x), y is \(result.y) at time t=\(result.t)")
                //                }
                //            }
                //            catch{
                //                print("Error: \(error).self")
                //            }
                default:
                ()
            }
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
