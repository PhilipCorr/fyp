//
//  GlyphView.swift
//  GlyphRecognizer
//
//  Created by Me on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class GlyphView: UIView {
    var glyph: Glyph? {
        didSet {
            glyph?.clientWidth = Double(self.bounds.size.width)
            glyph?.clientHeight = Double(self.bounds.size.height)
            self.setNeedsDisplay()
        }
    }
    var stroke: Stroke?
    var glyphStart = false
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        if let context = self.glyph?.managedObjectContext {
            switch gesture.state {
            case .began:
                self.stroke = Stroke(context: context)
                self.stroke?.glyph?.clientWidth = Double(self.bounds.size.width)
                self.stroke?.glyph?.clientHeight = Double(self.bounds.size.height)
                self.stroke?.duration = Double(CFAbsoluteTimeGetCurrent())
                self.glyph?.addToStrokes(self.stroke!)
                fallthrough
            case .changed:
                if let stroke =  self.stroke {
                    let touch = Touch(context: context)
                    touch.x = Double(gesture.location(in: self).x)
                    touch.y = Double(gesture.location(in: self).y)
                    touch.index = Int32((stroke.touches != nil) ? stroke.touches!.count : 0)
                    touch.timeStamp = Double(CFAbsoluteTimeGetCurrent()) - stroke.duration
                    stroke.addToTouches(touch)
                    self.setNeedsDisplay()
                }
            case .ended:
                if let stroke =  self.stroke {
                    stroke.duration = Double(CFAbsoluteTimeGetCurrent()) - stroke.duration
                }
                self.setNeedsDisplay()
            default: break
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        UIColor.black.setStroke()
        
        if let strokes = self.glyph?.strokes?.array as? [Stroke] {
            for stroke in strokes {
                if let path = stroke.path(rect: self.bounds, interpolation: .Cubic) {
                    path.lineCapStyle = .round
                    path.lineWidth = 8 * CGFloat(self.bounds.size.width / 375.0)
                    path.stroke()
                }
            }
        }
        
    }
    
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        if let touch = touches.first  {
    //            // print("\(touch.location(in: self))")
    //        }
    //    }
}
