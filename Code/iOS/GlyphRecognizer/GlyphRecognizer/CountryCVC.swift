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
    private let countries = [
        "IE","GB","CN","US","DE","FR","ES","IT","IN","AR","BR","PL",
        "NL","SG","PT","CA","NO","TR","RU","LU","BE","DK","SE","FI",
        
        "AD", "AE", "AF", "AG", "AI", "AL", "AM",
        "AO", "AQ", "AS", "AT", "AU", "AW", "AX", "AZ",
        "BA", "BB", "BD", "BF", "BG", "BH", "BI", "BJ", "BL",
        "BM", "BN", "BO", "BQ", "BS", "BT", "BV", "BW", "BY", "BZ",
        "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN",
        "CO", "CR", "CU", "CV", "CW", "CX", "CY", "CZ",
        "DJ", "DK", "DM", "DO", "DZ",
        "EC", "EE", "EG", "EH", "ER", "ET",
        "FI", "FJ", "FK", "FM", "FO",
        "GA", "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN",
        "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY",
        "HK", "HM", "HN", "HR", "HT", "HU",
        "ID", "IL", "IM", "IO", "IQ", "IR", "IS",
        "JE", "JM", "JO", "JP",
        "KE", "KG", "KH", "KI", "KM", "KN",
        "KP", "KR", "KW", "KY", "KZ",
        "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LV", "LY",
        "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK",
        "ML", "MM", "MN","MO", "MP", "MQ", "MR", "MS",
        "MT", "MU", "MV", "MW", "MX", "MY", "MZ",
        "NA", "NC", "NE", "NF", "NG", "NI", "NO", "NP", "NR", "NU", "NZ",
        "OM",
        "PA", "PE", "PF", "PG", "PH", "PK",
        "PM", "PN", "PR", "PS", "PW", "PY",
        "QA",
        "RE", "RO", "RS", "RU", "RW",
        "SA", "SB", "SC", "SD", "SH", "SI", "SJ", "SK", "SL", "SM",
        "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ",
        "TC", "TD", "TF", "TG", "TH", "TJ", "TK", "TL",
        "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ",
        "UA", "UG", "UM", "UY", "UZ",
        "VA", "VC", "VE", "VG", "VI", "VN", "VU",
        "WF", "WS",
        "YE", "YT",
        "ZA", "ZM", "ZW"]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Number of Countries: \(countries.count)")
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
        // cell.layer.borderWidth = 1.0
        // cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCountry = countries[indexPath.item]
        self.performSegue(withIdentifier: "Unwind Country CVC", sender: self)
        
    }
}


