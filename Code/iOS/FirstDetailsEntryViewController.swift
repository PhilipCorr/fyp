//
//  DetailsEntryViewController.swift
//  DataRecorder
//
//  Created by Student on 09/10/2016.
//  Copyright © 2016 GS. All rights reserved.
//

import UIKit

class FirstDetailsEntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var enterYear: UITextField!
    
    @IBOutlet var nextButton: UIButton!
    
    @IBOutlet var male: UIButton!
    
    @IBOutlet var female: UIButton!
    
    var gender = "male"
    
    @IBAction func changeGender(_ sender: UIButton) {
        switch sender {
        case male:
            self.female.alpha = 0.5
            self.male.alpha = 1
            gender = "male"
            break
        case female:
            self.male.alpha = 0.5
            self.female.alpha = 1
            gender = "female"
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.

        enterYear.keyboardType = UIKeyboardType.numberPad
        self.enterYear.becomeFirstResponder()
    }
    
    @IBAction func enterYearChanged(_ sender: UITextField) {
        if (enterYear.text?.characters.count)! >= 2{
            enterYear.resignFirstResponder()
        }
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

            dvc.age = enterYear.text!
            dvc.gender = gender
            
        }
    }


    
}

//extension UISegmentedControl {
//    func removeBorders() {
////        setBackgroundImage(imageWithColor(color: UIColor.clear), for: .normal, barMetrics: .default)
////        setBackgroundImage(imageWithColor(color: UIColor.clear), for: .selected, barMetrics: .default)
////        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//    }
//    
//    // create a 1x1 image with this color
//    private func imageWithColor(color: UIColor) -> UIImage {
//        let rect = CGRect(0.0, 0.0, 100.0, 100.0)
//        UIGraphicsBeginImageContext(rect.size)
//        let context = UIGraphicsGetCurrentContext()
//        context!.setFillColor(color.cgColor);
//        context!.fill(rect);
//        let image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        return image!
//    }
//}
//
//extension CGRect{
//    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
//        self.init(x:x,y:y,width:width,height:height)
//    }
//    
//}
