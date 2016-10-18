//
//  EnterNumbersView.swift
//  DataRecorder
//
//  Created by Student on 11/10/2016.
//  Copyright © 2016 GS. All rights reserved.
//

import UIKit

protocol NumbersEntryProtocol {
    var points :[CGPoint] { get }
}

class NumbersEntryView: UIView {
    
    var delegate: NumbersEntryProtocol?
    
    @IBAction func mymethod(_ sender: UIButton) {
    }
    
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        if let touch = touches.first  {
    //            // print("\(touch.location(in: self))")
    //        }
    //    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if let points = delegate?.points {
            UIColor.black.setStroke()
            if points.count > 0  {
                let path  = UIBezierPath.init()
                path.lineCapStyle = .round
                path.lineWidth = 8
                path.move(to: points[0])
                for dest in points[1..<points.count] {
                    path.addLine(to: dest)
                }
                path.stroke()
                print("\(path)")
            }
        }
    }
    
}
