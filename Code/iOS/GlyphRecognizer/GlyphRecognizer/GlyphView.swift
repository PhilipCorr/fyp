//
//  GlyphView.swift
//  GlyphRecognizer
//
//  Created by Me on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

extension Touch {
    func point(scale: Double = 1.0) -> CGPoint {
        return CGPoint(x: self.x * scale, y: self.y * scale)
    }
}

extension UIBezierPath
{
    static func InterpolateWithLinear(interpolationPoints : [CGPoint]) -> UIBezierPath? {
        guard interpolationPoints.count > 1 else { return nil }
        let path =  UIBezierPath()
        path.move(to: interpolationPoints[0])
        for point in interpolationPoints[1..<interpolationPoints.count] {
            path.addLine(to: point)
        }
        return path
    }

    static func interpolateWithCubic(interpolationPoints : [CGPoint], alpha : CGFloat = 1.0/3.0) -> UIBezierPath?
    {
        guard !interpolationPoints.isEmpty else { return nil }
        
        let path =  UIBezierPath()
        path.move(to: interpolationPoints[0])
        
        let n = interpolationPoints.count - 1
        
        for index in 0..<n
        {
            var currentPoint = interpolationPoints[index]
            var nextIndex = (index + 1) % interpolationPoints.count
            var prevIndex = index == 0 ? interpolationPoints.count - 1 : index - 1
            var previousPoint = interpolationPoints[prevIndex]
            var nextPoint = interpolationPoints[nextIndex]
            let endPoint = nextPoint
            var mx : CGFloat
            var my : CGFloat
            
            if index > 0
            {
                mx = (nextPoint.x - previousPoint.x) / 2.0
                my = (nextPoint.y - previousPoint.y) / 2.0
            }
            else
            {
                mx = (nextPoint.x - currentPoint.x) / 2.0
                my = (nextPoint.y - currentPoint.y) / 2.0
            }
            
            let controlPoint1 = CGPoint(x: currentPoint.x + mx * alpha, y: currentPoint.y + my * alpha)
            currentPoint = interpolationPoints[nextIndex]
            nextIndex = (nextIndex + 1) % interpolationPoints.count
            prevIndex = index
            previousPoint = interpolationPoints[prevIndex]
            nextPoint = interpolationPoints[nextIndex]
            
            if index < n - 1
            {
                mx = (nextPoint.x - previousPoint.x) / 2.0
                my = (nextPoint.y - previousPoint.y) / 2.0
            }
            else
            {
                mx = (currentPoint.x - previousPoint.x) / 2.0
                my = (currentPoint.y - previousPoint.y) / 2.0
            }
            
            let controlPoint2 = CGPoint(x: currentPoint.x - mx * alpha, y: currentPoint.y - my * alpha)
            
            path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        }
        return path
    }
}

extension Array {
    func dropout(_ step: Int) -> Array<Element> {
        var arr = Array<Element>()
        for i in stride(from: self.startIndex, to: self.endIndex, by: step) {
            arr.append(self[i])
        }
        return arr
    }
}

extension Stroke {
    enum InterpolationType {
        case Linear
        case Cubic
    }
    
    func path(scale: Double = 1.0, interpolation: InterpolationType = .Linear) -> UIBezierPath? {
        if let touches = self.touches?.array as? [Touch] , touches.count > 1 {
            let points = touches.map() {$0.point(scale: scale)}
            switch interpolation {
            case .Linear:
                return UIBezierPath.InterpolateWithLinear(interpolationPoints: points)
            case .Cubic:
                return UIBezierPath.interpolateWithCubic(interpolationPoints: points, alpha: 0.1)
            }
        } else {
            return nil
        }
    }
}

class GlyphView: UIView {
    var glyph: Glyph? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var stroke: Stroke?
    var glyphStartTime = 0.0
    var glyphStart = true
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        if let context = self.glyph?.managedObjectContext {
            switch gesture.state {
            case .began:
                self.stroke = Stroke(context: context)
                self.stroke?.duration = Double(CFAbsoluteTimeGetCurrent())
                self.glyph?.addToStrokes(self.stroke!)
                if(glyphStart){
                    glyphStartTime = Double(CFAbsoluteTimeGetCurrent())
                    glyphStart = false
                }
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
                    self.glyph?.duration = Double(CFAbsoluteTimeGetCurrent()) - glyphStartTime
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
                if let path = stroke.path(scale: Double(self.bounds.size.width) / self.glyph!.clientWidth, interpolation: .Cubic) {
                    path.lineCapStyle = .round
                    path.lineWidth = 8 * CGFloat(self.bounds.size.width) / CGFloat(self.glyph!.clientWidth)
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
