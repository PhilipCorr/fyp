//
//  SummaryVC.swift
//  GlyphRecognizer
//
//  Created by Me on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GlyphCell"

//class GlyphCell: UICollectionViewCell {
//    @IBOutlet weak var glyphImageView: UIImageView!
//}


class SummaryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    public var subject: Subject?
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var handLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        self.ageLabel.text = "\((self.subject?.age)!)"
        self.countryLabel.text = String.flag(country: (subject?.nativeLanguage)!)
        self.sexLabel.text = "\((self.subject?.sex)!)"
        self.handLabel.text = "\((self.subject?.handedness)!)"
        
        // Create new paths for output
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Get the Document directory path
        let dirPath:String = paths[0]
        var pathArray: [String] = [dirPath + "/images", dirPath + "/Pixels"]
        
        var objcBool:ObjCBool = true
        for directory in pathArray{
            let isExist = FileManager.default.fileExists(atPath: directory, isDirectory: &objcBool)
            // If the folder with the given path doesn't exist already, create it
            if isExist == false{
                do{
                    try FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
                }catch{
                    print("Something went wrong while creating a new folder")
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.subject?.glyphs?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GlyphCell
        
        // Configure the cell
        let glyph = self.subject!.glyphs!.array[indexPath.item] as? Glyph
        cell.glyphImageView.image = glyph?.image()
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let destinationVC = segue.destination as? ViewToBitMapVC {
            // create new subject and set model to new VC
            destinationVC.subject = self.subject
        }
    }
}
