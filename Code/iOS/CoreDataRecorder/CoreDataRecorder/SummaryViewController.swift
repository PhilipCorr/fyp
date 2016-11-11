//
//  SummaryViewController.swift
//  CoreDataRecorder
//
//  Created by Student on 05/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController {

    var language = "string"
    var age = "23"
    var gender = "female"
    var rightHanded = true
    
    @IBOutlet var NVal: UILabel!
    @IBOutlet var GVal: UILabel!
    @IBOutlet var AVal: UILabel!
    @IBOutlet var HVal: UILabel!
    
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
