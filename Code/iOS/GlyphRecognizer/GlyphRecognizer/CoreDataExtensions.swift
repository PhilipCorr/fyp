//
//  CoreDataExtensions.swift
//  GlyphRecognizer
//
//  Created by Me on 25/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

extension Glyph {
    
    enum Finger: String {
        case Index = "index"
        case Thumb = "thumb"
    }

    public func image(lineWidth: CGFloat = 1.0, size: CGSize = CGSize(width: 28, height: 28), padding: UIEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            UIColor.black.setFill()
            UIBezierPath(rect: CGRect(origin: CGPoint.zero, size: size)).fill()
            UIColor.white.setStroke()
            if let strokes = self.strokes?.array as? [Stroke], let boundingBox = self.boundingBox {
                let drawingRect = UIEdgeInsetsInsetRect(CGRect(origin: CGPoint.zero, size: size), padding)
                let scale = Double(max(drawingRect.width, drawingRect.height )) / Double(max(boundingBox.size.width, boundingBox.size.height))
                let offset = CGPoint(x: -boundingBox.origin.x + padding.left / CGFloat(scale) + (drawingRect.size.width / CGFloat(scale) - boundingBox.size.width) / CGFloat(2.0), y: -boundingBox.origin.y + padding.top / CGFloat(scale) + (drawingRect.size.height / CGFloat(scale) - boundingBox.size.height) / CGFloat(2.0)
                )
                for stroke in strokes {
                    if let path = stroke.path(offset: offset, scale: scale, interpolation: .Cubic) {
                        path.lineCapStyle = .round
                        path.lineWidth = lineWidth
                        path.stroke()
                    }
                }
            }
        }
        return image
    }
    
    var boundingBox: CGRect? {
        get {
            if let strokes = self.strokes?.array as? [Stroke] {
                var boundingBoxes = strokes.map {$0.boundingBox}
                if var boundingBox = boundingBoxes.first {
                    boundingBoxes.removeFirst()
                    for strokebbox in boundingBoxes {
                        if strokebbox != nil {
                            boundingBox = boundingBox?.union(strokebbox!)
                        }
                    }
                    return boundingBox
                }
            }
            return nil
        }
    }
    
}

extension Touch {
    func point(offset: CGPoint = CGPoint.zero, scale: Double = 1.0) -> CGPoint {
        return CGPoint(x: (self.x + Double(offset.x)) * scale, y: (self.y + Double(offset.y)) * scale)
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
    
    var boundingBox: CGRect? {
        get {
            if let touches = self.touches?.array as? [Touch] {
                let points = touches.map() { (x: $0.x, y: $0.y) }
                let max = points.reduce((x:0.0, y: 0.0), {
                    (x: Double.maximum($0.x, $1.x), y: Double.maximum($0.y, $1.y))
                })
                let min = points.reduce((x:Double.infinity, y: Double.infinity), {
                    (x: Double.minimum($0.x, $1.x), y: Double.minimum($0.y, $1.y))
                })
                return CGRect(x: min.x, y: min.y, width: max.x - min.x, height: max.y - min.y)
            } else {
                return nil
            }
        }
    }
    
    func path(rect: CGRect, interpolation: InterpolationType = .Linear) -> UIBezierPath? {
        
        if let glyph = self.glyph {
            let scale = Double(max(rect.size.width, rect.size.height)) / max(glyph.clientWidth, glyph.clientHeight)
            return self.path(scale: scale, interpolation: interpolation)
        } else {
            return nil
        }
    }
    
    func path(offset: CGPoint = CGPoint.zero, scale: Double = 1.0, interpolation: InterpolationType = .Linear) -> UIBezierPath? {
        if let touches = self.touches?.array as? [Touch] , touches.count > 1 {
            let points = touches.map() {$0.point(offset: offset, scale: scale)}
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

