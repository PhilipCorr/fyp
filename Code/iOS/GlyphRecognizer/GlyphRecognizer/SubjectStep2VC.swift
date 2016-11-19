//
//  SubjectStep2VC.swift
//  GlyphRecognizer
//
//  Created by Student on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class SubjectStep2VC: UIViewController {
    // datamodel
    var subject: Subject?
    
    
    @IBOutlet var countryButton: UIButton!
    @IBOutlet var leftHandButton: UIButton!
    @IBOutlet var rightHandButton: UIButton!
    
    @IBAction func changeHand(_ sender: UIButton) {
        switch sender {
        case leftHandButton:
            subject?.handedness = Subject.HandedNess.Left.rawValue
        case rightHandButton:
            subject?.handedness = Subject.HandedNess.Right.rawValue
        default:
            break
        }
        self.updateUI()
    }
    
    func updateUI() {
        countryButton.setTitle(subject?.nativeLanguage, for: .normal)
        if let handedness = subject?.handedness {
            switch handedness {
            case Subject.HandedNess.Left.rawValue:
                self.rightHandButton.alpha = 0.25
                self.leftHandButton.alpha = 1
            case Subject.HandedNess.Right.rawValue:
                self.leftHandButton.alpha = 0.25
                self.rightHandButton.alpha = 1
            default:
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(subject?.description)
        if self.subject?.sex == Subject.Sex.Male.rawValue {
            self.view.backgroundColor = UIColor(hue: 0.5, saturation: 1, brightness: 0.2, alpha: 1.0)
        } else {
            self.view.backgroundColor = UIColor(hue: 0.83, saturation: 1, brightness: 0.2, alpha: 1.0)
        }
        
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dvc = segue.destination as? GlyphEntryVC {
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            dvc.subject = self.subject
        }
        
    }
    
    func unwindfromCollectionView(segue: UIStoryboardSegue) {
        if let svc = segue.source as? CountryCVC {
            subject?.nativeLanguage = svc.country
            updateUI()
        }
    }
}
