//
//  SummaryVC.swift
//  GlyphRecognizer
//
//  Created by Me on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

private let reuseIdentifier = "GlyphCell"

class GlyphCell: UICollectionViewCell {
    
    @IBOutlet var glyphView: GlyphView! {
        didSet {
            glyphView.isUserInteractionEnabled = false
        }
    }
}


class SummaryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    public var subject: Subject?
    
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        self.ageLabel.text = "\(self.subject?.age) YEARS OLD"
        self.countryLabel.text = String.flag(country: (subject?.nativeLanguage)!)
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
        cell.glyphView.glyph = self.subject!.glyphs!.array[indexPath.item] as? Glyph
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
