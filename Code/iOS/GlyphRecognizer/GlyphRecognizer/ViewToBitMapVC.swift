//
//  ViewToBitMap.swift
//  GlyphRecognizer
//
//  Created by Student on 23/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GlyphCell"


class ViewToBitMapVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    public var subject: Subject?
    var imagesDirectoryPath:String!
    var images:[UIImage]!
    var titles:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Get the Document directory path
        let documentDirectoryPath:String = paths[0]
        // Create a new path for the new images folder
        imagesDirectoryPath = documentDirectoryPath + "/Images"
        
        var objcBool:ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: imagesDirectoryPath, isDirectory: &objcBool)
        // If the folder with the given path doesn't exist already, create it
        if isExist == false{
            do{
                try FileManager.default.createDirectory(atPath: imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("Something went wrong while creating a new folder")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        cell.exportGlyphImageView.image = glyph?.image()
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        
        // Save image to Document directory
        var imagePath = "index\((glyph?.index)!)-num\((glyph?.character!)!)-\(NSDate().description))" //NSDate().description is current date and time
        imagePath = imagesDirectoryPath + "/\(imagePath).png"
        let data = UIImagePNGRepresentation((glyph?.image())!)
        let success = FileManager.default.createFile(atPath: imagePath, contents: data, attributes: nil)
        
        return cell
    }
    
    @IBAction func exportImages(_ sender: UIButton)
    {
        // let image = UIImage(view: GlyphView)
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

