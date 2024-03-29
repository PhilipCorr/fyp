//
//  DetailsEntryViewController.swift
//  DataRecorder
//
//  Created by Student on 09/10/2016.
//  Copyright © 2016 GS. All rights reserved.
//

import UIKit

class DetailsEntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var enterYear: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBOutlet var datePicker: UIDatePicker!
    
    var touchesCount = 0 {
        didSet {
            print("\(touchesCount)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.enterYear.delegate = self;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let dvc = segue.destination as? EnterNumbersViewController {
            
            //let calendar = NSCalendar.current
            dvc.age = Int(self.enterYear.text!)!
        }
    }
    
    @IBAction func unwindToDetailsVC(segue: UIStoryboardSegue) {
        if let svc = segue.source as? EnterNumbersViewController {
            self.touchesCount = svc.points.count
        }

    }
    
}
