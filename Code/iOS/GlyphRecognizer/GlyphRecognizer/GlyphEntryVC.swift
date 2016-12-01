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
    public var segueId: String?
    
    public var index = 0
    private var glyphs = [Glyph]()
    public var fingerType = Glyph.Finger.Index
    
    @IBOutlet weak var glyphView: GlyphView!
    
    private var characterToBeDrawn = [String]()
    let synthesizer = AVSpeechSynthesizer()

    
    func randomNumbers(range: Range<Int>) -> [Int] {
        let min = range.lowerBound
        let max = range.upperBound
        
        var unshuffledNumbers = [Int]()
        
        for _ in 1..<5 {
            unshuffledNumbers.append(contentsOf: Array(min..<max))
        }
        
        let shuffledNumbers = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: unshuffledNumbers)
        return shuffledNumbers as! [Int]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(subject?.description ?? "invalid")

        characterToBeDrawn = randomNumbers(range: 0..<10).map {"\($0)"}
        print("\(characterToBeDrawn)")
        let toSpeak = fingerType == .Index ? "\(fingerType) finger" : "\(fingerType)"
        synthesizer.speak(AVSpeechUtterance(string: "Please draw the following numbers using your \(toSpeak)"))
        newInstruction()
    }
    
    override func viewDidLayoutSubviews() {
        self.glyphView.glyph?.clientWidth = Double(self.glyphView.bounds.size.width)
        self.glyphView.glyph?.clientHeight = Double(self.glyphView.bounds.size.height)
    }
    
    func newInstruction() {
        self.glyphView.glyphStart = true
        if let character = characterToBeDrawn.last
        {
            index = index + 1
            let newGlyph = Glyph(context: (self.subject?.managedObjectContext)!)
            newGlyph.character = character
            newGlyph.index = Int32(index)
            newGlyph.finger = fingerType.rawValue
            synthesizer.speak(AVSpeechUtterance(string: character))
            self.glyphs.append(newGlyph)
            characterToBeDrawn.removeLast()
            self.glyphView.glyph = newGlyph
        }
        else
        {
            self.glyphView.isUserInteractionEnabled = false
            for glyph in self.glyphs {
                self.subject?.addToGlyphs(glyph)
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.performSegue(withIdentifier: self.segueId!, sender: self)
        }
        print("width = \(self.glyphView.glyph?.clientWidth)")
    }
    
    @IBAction func redo(_ sender: UIButton) {
        if let glyph = glyphs.last
        {
            characterToBeDrawn.append(glyph.character!)
            self.subject?.managedObjectContext?.delete(glyph)
            glyphs.removeLast()
            newInstruction()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {        
        if let destinationVC = segue.destination as? SwapFingerVC {
            destinationVC.subject = self.subject
            destinationVC.index = index
        } else if let destinationVC = segue.destination as? SummaryVC {
            destinationVC.subject = self.subject
        }
    }
    
    
    @IBAction func nextNumber(_ sender: ProgressButton) {
        if (self.glyphView.glyph?.strokes?.count)! > 0 {
            sender.progress = CGFloat(self.glyphs.count) / CGFloat(self.glyphs.count + self.characterToBeDrawn.count)
            newInstruction()
        }
        
        print(subject?.description ?? "invalid")
    }
}

