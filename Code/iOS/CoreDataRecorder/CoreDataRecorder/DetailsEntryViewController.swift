//
//  DetailsEntryViewController.swift
//  DataRecorder
//
//  Created by Student on 09/10/2016.
//  Copyright © 2016 GS. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class DetailsEntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var enterYear: UITextField!
    
    @IBOutlet var nextButton: UIButton!

    @IBOutlet var currentCountry: UIButton!
    
    @IBOutlet var gender: UISegmentedControl!
    
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            gender.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.init(red: 26, green: 163, blue: 255, alpha: 1)], for: .selected)
            gender.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.init(red: 255, green: 128, blue: 223, alpha: 0.5)], for: .normal)
        case 1:
            gender.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.init(red: 26, green: 163, blue: 255, alpha: 0.5)], for: .selected)
            gender.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.init(red: 255, green: 128, blue: 223, alpha: 1)], for: .normal)
        default:
            break;
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
//    func textField(_ textField: enterYear, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let text: NSString = (textField.text ?? "") as NSString
//        let resultString = text.replacingCharacters(in: range, with: string)
//        
//        return true
//    }

    
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
        
        
//        gender.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: UIFont.fontAwesome(ofSize: 20))! ], forState: .Normal)
//        gender.titleForSegment(at: 0) = String.fontAwesomeIcon(code: "fa-mars")
//        gender.titleForSegment(at: 1) = String.fontAwesomeIcon(code: "fa-venus")
        //segmentedControl.setFAIcon(FAType.FATwitter, forSegmentAtIndex: 0)
        
        gender.setFAIcon(icon: FAType.FAMars, forSegmentAtIndex: 0)
        gender.setFAIcon(icon: FAType.FAVenus, forSegmentAtIndex: 1)
        gender.removeBorders()
        
        gender.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.init(red: 26, green: 163, blue: 255, alpha: 1)], for: .selected)
        gender.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.init(red: 255, green: 128, blue: 223, alpha: 0.5)], for: .normal)

        //self.enterYear.delegate = self;
        enterYear.keyboardType = UIKeyboardType.numberPad
        currentCountry.setTitle(flag(country: "IE"), for: .normal)
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

            dvc.language = currentCountry.title(for: .normal)!
            dvc.age = enterYear.text!
            dvc.gender = gender.titleForSegment(at: gender.selectedSegmentIndex)!
            
        }
    }

    @IBAction func unwindfromCollectionView(segue: UIStoryboardSegue) {
        if let svc = segue.source as? CollectionViewController {
            //self.touchesCount = svc.points.count
            currentCountry.setTitle(flag(country: svc.dataToSend), for: .normal)

        }
        
    }
    
}

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: UIColor.red), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: UIColor.green), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.black), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(0.0, 0.0, 100.0, 100.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }
    
}
