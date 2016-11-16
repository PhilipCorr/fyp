//
//  SummaryViewController.swift
//  CoreDataRecorder
//
//  Created by Student on 05/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit
import CoreData

class SummaryViewController: UIViewController {
    
    let context = DatabaseController.persistentContainer.viewContext
    let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask).first!

    
    var language = "string"
    var age = "23"
    var gender = "male"
    var rightHanded = true
    
    @IBOutlet var NVal: UILabel!
    @IBOutlet var GVal: UILabel!
    @IBOutlet var AVal: UILabel!
    @IBOutlet var HVal: UILabel!
    @IBOutlet var DBVal: UILabel!
    
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NVal.text = language
        GVal.text = gender
        AVal.text = age
        if rightHanded{
            HVal.text = "Right"
        }
        else{
            HVal.text = "Left"
        }

        let personClassName:String = String(describing: Person.self)

        let person:Person = NSEntityDescription.insertNewObject(forEntityName: personClassName, into: context) as! Person
        
        person.a = Int32(age)!
        person.h = HVal.text
        person.n = language
        person.s = gender
        
        DatabaseController.saveContext()

        
        let fetchRequest:NSFetchRequest<Person> = Person.fetchRequest()
        do{
            let searchResults = try context.fetch(fetchRequest)
            print("Number of People currently in database: \(searchResults.count)")
            print("database directory: \(documentsUrl)")

            DBVal.text = String(searchResults.count)
//            for result in searchResults as [Person]{
//                print("x is \(result.), y is \(result.y) at time t=\(result.t)")
//            }
        }
        catch{
            print("Error: \(error).self")
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
