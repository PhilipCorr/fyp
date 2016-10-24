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
    
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    var touchesCount = 0 {
        didSet {
            print("\(touchesCount)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.enterYear.delegate = self;
        currentCountry.text = flag(country: "IE")
        irishFlag.text = flag(country: "IE")
        germanFlag.text = flag(country: "DE")
        frenchFlag.text = flag(country: "FR")
        americanFlag.text = flag(country: "US")
        chineseFlag.text = flag(country: "CN")
        indianFlag.text = flag(country: "IN")

    }
    
    
    @IBOutlet var flags: UICollectionView!
    
    @IBOutlet var currentCountry: UILabel!
    @IBOutlet var irishFlag: UILabel!
    @IBOutlet var germanFlag: UILabel!
    @IBOutlet var frenchFlag: UILabel!
    @IBOutlet var americanFlag: UILabel!
    @IBOutlet var chineseFlag: UILabel!
    @IBOutlet var indianFlag: UILabel!
    
    @IBAction func changecountry(_ sender: UITapGestureRecognizer) {
        currentCountry.text = flag(country: "DE")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let dvc = segue.destination as? NumbersEntryViewController {
            
            //let calendar = NSCalendar.current
            dvc.age = Int(self.enterYear.text!)!
        }
    }
    
    @IBAction func unwindToDetailsVC(segue: UIStoryboardSegue) {
        if let svc = segue.source as? NumbersEntryViewController {
            self.touchesCount = svc.points.count
        }
        
    }
    
}
