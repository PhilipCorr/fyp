//
//  ProgressButton.swift
//  GlyphRecognizer
//
//  Created by Student on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class ProgressButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = self.tintColor.cgColor
        self.layer.borderWidth =  1.0
    }
    
    @IBInspectable public var step:Int = 39
    
    
    // between 0 and 1
    public var progress: CGFloat = 0.0 {
        didSet {
            if progress > 1.0 {
                progress = 1.0
            } else if progress < 0.0 {
                progress = 0.0
            }
            self.setNeedsDisplay()
        }
    }
    
    func increment() {
        //        if progress >= 1.0 {
        //            step *= -1
        //        } else if progress <= 0.0 {
        //            step *= -1
        //        }
        progress += 1.0 / CGFloat(step)
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let progressRect = CGRect(x: 0, y: 0 * self.bounds.height, width: self.bounds.width * progress, height:  200)
        let path = UIBezierPath(rect: progressRect)
        UIColor.init(red: 51/255, green: 133/255, blue: 255/255, alpha: 1).setFill()
        path.fill()
    }
}
