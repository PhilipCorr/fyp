//
//  SecondDetailsEntryViewController.swift
//  CoreDataRecorder
//
//  Created by Student on 10/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class SecondDetailsEntryViewController: UIViewController {
    
    
    @IBOutlet var currentCountry: UIButton!
    
    @IBOutlet var leftButton: UIButton!
    
    @IBOutlet var rightButton: UIButton!
    
    var age = "10"
    var gender = "male"
    var rightHanded = true
    
    
    @IBAction func changeHand(_ sender: UIButton) {
        switch sender {
        case leftButton:
            self.rightButton.alpha = 0.5
            self.leftButton.alpha = 1
            rightHanded = false
            break
        case rightButton:
            self.leftButton.alpha = 0.5
            self.rightButton.alpha = 1
            rightHanded = true
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentCountry.setTitle(flag(country: "IE"), for: .normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dvc = segue.destination as? NumbersEntryViewController {
            
            dvc.language = currentCountry.title(for: .normal)!
            dvc.age = age
            dvc.gender = gender
            dvc.rightHanded = rightHanded
            
        }
        
    }
    
    func unwindfromCollectionView(segue: UIStoryboardSegue) {
        if let svc = segue.source as? CollectionViewController {
            //self.touchesCount = svc.points.count
            currentCountry.setTitle(flag(country: svc.dataToSend), for: .normal)
            
        }
        
    }
    

}
