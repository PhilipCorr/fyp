//
//  SubjectStep1VC.swift
//  GlyphRecognizer
//
//  Created by Student on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class SubjectStep1VC: UIViewController, UITextFieldDelegate {
    // data model
    var subject: Subject?
    
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    
    @IBAction func changeGender(_ sender: UIButton) {
        switch sender {
        case self.maleButton:
            self.femaleButton.alpha = 0.25
            self.maleButton.alpha = 1
            self.subject?.sex = Subject.Sex.Male.rawValue
            break
        case self.femaleButton:
            self.maleButton.alpha = 0.25
            self.femaleButton.alpha = 1
            self.subject?.sex = Subject.Sex.Female.rawValue

            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.subject?.age = Int32(textField.text!)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        // Do any additional setup after loading the view.
        self.yearTextField.becomeFirstResponder()
        
        self.changeGender(self.femaleButton)
        self.femaleButton.layer.borderWidth = 1.0
        self.maleButton.layer.borderWidth = 1.0
        self.femaleButton.layer.borderColor = UIColor.gray.cgColor
        self.maleButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    @IBAction func enterYearChanged(_ sender: UITextField) {
        if (yearTextField.text?.characters.count)! == 2{
            yearTextField.resignFirstResponder()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? SubjectStep2VC {
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            subject?.nativeLanguage = "IE"
            subject?.handedness = Subject.HandedNess.Left.rawValue
            destinationVC.subject = subject
        }
    }
}

extension Subject {
    enum HandedNess: String {
        case Left = "left-handed"
        case Right = "right-handed"
    }
    enum Sex: String {
        case Male = "male"
        case Female = "female"
    }
}
