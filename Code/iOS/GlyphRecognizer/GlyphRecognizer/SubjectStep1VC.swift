//
//  SubjectStep1VC.swift
//  GlyphRecognizer
//
//  Created by Student on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class SubjectStep1VC: UIViewController, UITextFieldDelegate {
    // datamodel
    var subject: Subject?
    
    @IBOutlet var yearTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var maleButton: UIButton!
    @IBOutlet var femaleButton: UIButton!
    
    @IBAction func changeGender(_ sender: UIButton) {
        switch sender {
        case maleButton:
            self.femaleButton.alpha = 0.25
            self.maleButton.alpha = 1
            subject?.sex = Subject.Sex.Male.rawValue
            break
        case femaleButton:
            self.maleButton.alpha = 0.25
            self.femaleButton.alpha = 1
            subject?.sex = Subject.Sex.Female.rawValue

            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        subject?.age = Int32(textField.text!)!
    }
    
    
    func didTapDone(sender: AnyObject?) {
        yearTextField.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        yearTextField.keyboardType = UIKeyboardType.numberPad
        self.yearTextField.becomeFirstResponder()
        self.changeGender(self.femaleButton)
    }
    
    @IBAction func enterYearChanged(_ sender: UITextField) {
        if (yearTextField.text?.characters.count)! == 2{
            yearTextField.resignFirstResponder()
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let dvc = segue.destination as? SubjectStep2VC {
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            subject?.nativeLanguage = String.flag(country:  "IE")
            subject?.handedness = Subject.HandedNess.Left.rawValue
            dvc.subject = subject
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
