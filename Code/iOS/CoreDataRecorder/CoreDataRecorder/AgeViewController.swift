//
//  AgeViewController.swift
//  CoreDataRecorder
//
//  Created by Student on 02/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class AgeViewController: UIViewController {

    @IBOutlet var age: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        age.keyboardType = UIKeyboardType.numberPad

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
