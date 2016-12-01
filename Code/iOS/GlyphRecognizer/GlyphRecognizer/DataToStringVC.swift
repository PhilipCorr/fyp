//
//  TestVC.swift
//  GlyphRecognizer
//
//  Created by Student on 22/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

extension Glyph {
    static func DataToString() -> String {
        return "string"
    }
}

class TestVC: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //@IBAction func exportData(_ sender: UIButton) {
      //  let context = appDelegate.persistentContainer.viewContext

//        let fetchRequest:NSFetchRequest<Glyph> = Glyph.fetchRequest()
  //          do{
    //            let searchResults = try context.fetch(fetchRequest)
      //          print("Number of results: \(searchResults.count)")
        //        for result in searchResults as [Touch]{
          //          print("x is \(result.x), y is \(result.y) at time t=\(result.t)")
            //    }
            //}
            //catch{
            //    print("Error: \(error).self")
           // }
     
   // }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}




