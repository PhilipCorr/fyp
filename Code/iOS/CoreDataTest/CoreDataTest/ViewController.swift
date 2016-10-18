//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Student on 18/10/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        var touch = Touch(context: context)
        touch.index = 8
        touch.x = 10
        
        let request: NSFetchRequest<Touch> = Touch.fetchRequest()
        request.fetchBatchSize = 10
        do {
            let searchResults = try context.fetch(request)
            
            print ("num of results = \(searchResults.count)")
            
            for touch in searchResults as [Touch] {
                print("\(touch.x)")
            }
        
        } catch {
            print("Error with request: \(error)")
        }
        
        let stroke = Stroke(context: context)
        stroke.addToTouches(touch)
        
        touch = Touch(context: context)
        touch.index = 9
        stroke.addToTouches(touch)
        
        let request2: NSFetchRequest<Stroke> = Stroke.fetchRequest()
        request2.fetchBatchSize = 10
        do {
            let searchResults = try context.fetch(request2)
            
            print ("num of results = \(searchResults.count)")
        } catch {
            print("Error with request: \(error)")
        }

        
    }

}

