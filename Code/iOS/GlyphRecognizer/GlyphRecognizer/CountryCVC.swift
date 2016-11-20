//
//  CountryCVC.swift
//  GlyphRecognizer
//
//  Created by Student on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CountryCell"

class CountryCell: UICollectionViewCell {
    
    @IBOutlet var countryLabel: UILabel!
    
}


class CountryCVC: UICollectionViewController {
    public var selectedCountry: String?
    private let countries = ["IE","DE","FR","ES","US","CN","IN","PL","PT","NO","IT","TR","RU","NL","LU","BE","DK","SE","FI","GR"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.countries.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CountryCell
        
        // Configure the cell
        cell.countryLabel.text = String.flag(country: self.countries[indexPath.item])
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCountry = countries[indexPath.item]
        self.performSegue(withIdentifier: "Unwind Country CVC", sender: self)
        
    }
}


