//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Student on 05/10/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {
    
    @IBOutlet weak var faceView: FaceView!{
        didSet{
            faceView.dataSource = self
            //            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: ("scale:")))
        }
    }
    
    var scale: CGFloat = 1 {
        didSet{
            
        }
    }
    var happiness: Int = 75 { // 0 = sad, 100 = happy
        didSet{
            happiness = min(max(happiness, 0), 100)
            print("happiness = \(happiness)")
            updateUI()
        }
    }
    
    
    @IBAction func changeHappiness(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case.ended: fallthrough
        case.changed:
            let translation = gesture.translation(in: faceView)
            let happinessChange = -Int(translation.y / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPoint.zero, in: faceView)
            }
        default: break
        }
    }
    
    private struct Constants{
        static let HappinessGestureScale: CGFloat = 4
    }
    
    
    private func updateUI(){
        faceView.setNeedsDisplay()
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50)/50
    }
    
}
