//
//  SwapFingerVC.swift
//  GlyphRecognizer
//
//  Created by Me on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class SwapFingerVC: UIViewController {
    // datamodel
    public var subject: Subject?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationVC = segue.destination as? GlyphEntryVC {
            destinationVC.subject = self.subject
            destinationVC.segueId = "Show Summary VC"
            destinationVC.navigationItem.hidesBackButton = true
        }
    }

}
