//
//  MyView.swift
//  Test
//
//  Created by Me on 27/09/2016.
//  Copyright © 2016 GS. All rights reserved.
//

import UIKit

class MyView: UIView {
    
    var points = [CGPoint]()
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first  {
            print("\(touch.location(in: self))")
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code

        UIColor.lightGray.setStroke()
        if points.count > 0  {
            let path  = UIBezierPath.init()
            path.lineCapStyle = .round
            path.lineWidth = 8
            path.move(to: points[0])
            for dest in points[1..<points.count] {
                path.addLine(to: dest)
            }
            path.stroke()
        }
        
    }
    
}
