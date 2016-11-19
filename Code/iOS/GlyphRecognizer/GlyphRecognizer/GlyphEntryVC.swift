//
//  GlyphEntryVC.swift
//  GlyphRecognizer
//
//  Created by Student on 15/11/2016.
//  Copyright © 2016 UCD. All rights reserved.
//

import UIKit
import AVFoundation
import GameKit

class GlyphEntryVC: UIViewController {
    // datamodel
    public var subject: Subject?
    private var glyphs = [Glyph]()
    
    private var characterToBeDrawn = [String]()
    let synthesizer = AVSpeechSynthesizer()
    private var utterance = AVSpeechUtterance(string: "Please draw the following numbers using your index finger")

    
    override func viewWillAppear(_ animated: Bool) {
        self.updateUI()
    }
    
    func randomNumbers(range: Range<Int>) -> [Int] {
        let min = range.lowerBound
        let max = range.upperBound
        
        var unshuffledNumbers = [Int]()
        
        for _ in 1...8 {
            unshuffledNumbers.append(contentsOf: Array(min..<max))
        }
        
        let shuffledNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: unshuffledNumbers)
        return shuffledNumbers as! [Int]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        synthesizer.speak(utterance)
        characterToBeDrawn = randomNumbers(range: 0..<10).map {"\($0)"}
        newInstruction()
    }
    
    func newInstruction() {
        if let character = characterToBeDrawn.last
        {
            let newGlyph = Glyph(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
            newGlyph.character = character
            utterance = AVSpeechUtterance(string: character)
            synthesizer.speak(utterance)
            self.glyphs.append(newGlyph)
            characterToBeDrawn.removeLast()
        } else {
            for glyph in self.glyphs {
                self.subject?.addToGlyphs(glyph)
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.shouldPerformSegue(withIdentifier: "Show Next Step", sender: self)
            
        }
    }
    
    //  declared to be an implicitly unwrapped optional
    //  because it doesn't make sense to give it a non-nil initial value.
    private var glyphVC: GlyphVC!
    
    var complete = false
    
    
    func  updateUI() {
        // redraw custom view using last glyphs item
    }
    
    @IBAction func redo(_ sender: UIButton) {
        if let glyph = glyphs.last
        {
            characterToBeDrawn.append(glyph.character!)
            (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.delete(glyph)
            glyphs.removeLast()
            newInstruction()
        }
    }
    
    
    @IBAction func nextNumber(_ sender: ProgressButton) {
        newInstruction()
        sender.progress = CGFloat(self.glyphs.count) / CGFloat(self.glyphs.count + self.characterToBeDrawn.count)

    }
    

    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let dvc = segue.destination as? SummaryViewController {
            dvc.language = language
            dvc.age = age
            dvc.gender = gender
            dvc.rightHanded = rightHanded
        }
        
        if let evc = segue.destination as? DrawViewController{
            self.embeddedViewController = evc
        }
    }
    
    @IBAction func unwindfromChangeFingerView(segue: UIStoryboardSegue) {
        if let svc = segue.source as? ChangeToThumbViewController {
            //self.touchesCount = svc.points.count
            count = svc.count
            self.embeddedViewController.points = [CGPoint]()
            self.embeddedViewController.updateUI()
            utterance = AVSpeechUtterance(string: "Please draw the following numbers using your Thumb")
            synthesizer.speak(utterance)
            utterance = AVSpeechUtterance(string: "\(numbersToSpeak[40])")
            synthesizer.speak(utterance)
        }
    }
    
    //  Now in other methods you can reference `embeddedViewController`.
    //  For example:
    //    override func viewDidAppear(animated: Bool) {
    //        self.embeddedViewController.points
    //    }
    
    
    
    //    func prepare(for segue: "completionSegue", sender: AnyObject?) {
    //        if segue.identifier == "completionSegue" {
    //            if let viewController = segue.destination as? HappinessViewController {
    //                //viewController.property = property
    //            }
    //        }
    //    }
    
    
}

